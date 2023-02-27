//
//  PosterImageRepositoryMock.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/27.
//

import Foundation
import RxSwift
import UIKit
@testable import BoxOffice2

final class PosterImageRepositoryMock: PosterImageRepository {
    var fetchPosterImageCallCount = 0
    
    func fetchPosterImage(with title: String, year: String?) -> Observable<UIImage?> {
        fetchPosterImageCallCount += 1
        return Observable.create { emitter in
            if title == "invalid" {
                emitter.onError(PosterImageRepositoryMockError.unknown)
            } else {
                emitter.onNext(UIImage())
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}

enum PosterImageRepositoryMockError: LocalizedError {
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "알 수 없는 에러 발생"
        }
    }
}
