//
//  APIClient.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation
import RxSwift

struct APIClient {
    static let shared = APIClient(sesseion: URLSession.shared)
    private let session: URLSessionProtocol
    
    func requestData(with urlRequest: URLRequest) -> Observable<Data> {
        
        return Observable.create { emitter in
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
                guard error == nil else {
                    emitter.onError(APIError.unknown)
                    return
                }
                let successRange = 200..<300
                if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                   successRange.contains(statusCode) == false {
                    emitter.onError(APIError.response(statusCode))
                    return
                }
                guard let data = data else {
                    emitter.onError(APIError.unknown)
                    return
                }
                emitter.onNext(data)
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
//                task.cancel()
                //이게 있음면 mockURLSession 테스트에서 계속 cancel오류가 뜸 ..
            }
        }
    }
    
    init(sesseion: URLSessionProtocol) {
        self.session = sesseion
    }
}

// MARK: - URLSession Protocol
protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
