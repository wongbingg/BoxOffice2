//
//  API.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation
import RxSwift

protocol API {
    associatedtype ResponseType: Decodable, DTO
    var configuration: APIConfiguration { get }
}

extension API {
    
    func execute(using client: APIClient = APIClient.shared) -> Observable<ResponseType> {
        guard let urlRequest = configuration.makeURLRequest() else {
            return Observable.empty()
        }
        
        return Observable<ResponseType>.create { emitter in
            client.requestData(with: urlRequest)
                .subscribe { data in
                    do {
                        let result = try JSONDecoder().decode(ResponseType.self, from: data)
                        emitter.onNext(result)
                    } catch let error {
                        emitter.onError(error)
                    }
                } onError: { error in
                    emitter.onError(error)
                } onCompleted: {
                    emitter.onCompleted()
                }
        }
    }
}
