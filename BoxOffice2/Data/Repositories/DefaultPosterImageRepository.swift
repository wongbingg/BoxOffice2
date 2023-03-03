//
//  DefaultPosterImageRepository.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/26.
//

import RxSwift
import UIKit

final class DefaultPosterImageRepository: PosterImageRepository {
    private let imageCacheManager: ImageCacheManager
    private var urlHistory: [String: String] = [:]
    
    init(imageCacheManager: ImageCacheManager) {
        self.imageCacheManager = imageCacheManager
    }
    
    func fetchPosterImage(with title: String, year: String? = nil) -> Observable<UIImage?> {
        return Observable.create { [weak self] emitter in
            if let urlString = self?.urlHistory[title] {
                return self?.fetchPosterInCache(with: URL(string: urlString), emitter: emitter) ?? Disposables.create()
            } else {
                return SearchMoviePosterAPI(movieTitle: title, year: year).execute()
                    .subscribe { moviePosterResponseDTO in
                        let urlString = moviePosterResponseDTO.toDomain()
                        self?.urlHistory[title] = urlString

                        let url = URL(string: urlString)
                        _ = self?.fetchPosterInCache(with: url, emitter: emitter)

                    } onError: { error in
                        emitter.onError(error)
                    } onCompleted: {
                        emitter.onCompleted()
                    }
            }
        }
    }
    
    private func fetchPosterInCache(with url: URL?, emitter: AnyObserver<UIImage?>) -> Disposable {
        imageCacheManager.getImage(with: url)
            .subscribe { image in
                guard let image = image else { return }
                emitter.onNext(image)
            } onError: { error in
                emitter.onError(error)
            } onCompleted: {
                emitter.onCompleted()
            }
    }
}
