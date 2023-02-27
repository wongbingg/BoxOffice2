//
//  ImageCacheManager.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit
import RxSwift
import ImageIO

protocol ImageCacheManager {
    func getImage(with imageURL: URL?) -> Observable<UIImage?>
}

final class DefaultImageCacheManager: ImageCacheManager {
    private let disposeBag = DisposeBag()
    private let cache = URLCache.shared
    private var dataTask: URLSessionDataTask?
    
    func getImage(with imageURL: URL?) -> Observable<UIImage?> {
        
        return Observable.create { emitter in
            guard let imageURL = imageURL else {
                emitter.onError(ImageCacheError.invalidURL)
                return Disposables.create()
            }
            let request = URLRequest(url: imageURL)
            if self.cache.cachedResponse(for: request) != nil {
                let image = self.loadImageFromCache(with: imageURL)
                emitter.onNext(image)
                emitter.onCompleted()
                return Disposables.create()
            } else {
                return self.downloadImage(with: imageURL)
                    .subscribe { image in
                        emitter.onNext(image)
                    } onError: { error in
                        emitter.onError(error)
                    } onCompleted: {
                        emitter.onCompleted()
                    }
            }
        }
    }
    
    private func loadImageFromCache(with imageURL: URL) -> UIImage? {
        let request = URLRequest(url: imageURL)
        
        guard let data = self.cache.cachedResponse(for: request)?.data,
              let image = UIImage(data: data) else { return nil }
        return image
    }
    
    private func downloadImage(with imageURL: URL) -> Observable<UIImage?> {
        
        return Observable.create { emitter in
            let request = URLRequest(url: imageURL)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                   (200..<300).contains(statusCode) == false {
                    emitter.onError(ImageCacheError.statucCode(statusCode))
                    return
                }
                guard let data = data, let response = response else {
                    emitter.onError(ImageCacheError.unknown)
                    return
                }
                let cachedData = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cachedData, for: request)
                guard let image = UIImage(data: data) else { return }
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func downloadImageWithDownSampling(with imageURL: URL) -> Observable<UIImage?> {
        
        return Observable.create { emitter in
            
            let imageSourceOptions =  [kCGImageSourceShouldCache: false] as CFDictionary
            guard let imageSource = CGImageSourceCreateWithURL(
                imageURL as CFURL, imageSourceOptions
            ) else {
                print("failed to create image source")
                return Disposables.create()
            }
            
            let maxDimensionInPixels = 200
            let downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
            ] as CFDictionary
            
            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
                imageSource, 0, downsampleOptions
            ) else {
                print("fail to downsample")
                return  Disposables.create()
            }
            let image = UIImage(cgImage: downsampledImage)
            emitter.onNext(image)
            emitter.onCompleted()
            return Disposables.create()
        }
    }
}

enum ImageCacheError: LocalizedError {
    case unknown
    case invalidURL
    case statucCode(Int)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "알 수 없는 LoginCacheError 발생"
        case .invalidURL:
            return "URL이 유효하지 않습니다."
        case .statucCode(let code):
            return "현재코드 \(code) 가 범위를 넘었습니다."
            
        }
    }
}
