//
//  MovieRepositoryMock.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/27.
//

import Foundation
import RxSwift
@testable import BoxOffice2

final class MovieRepositoryMock: MovieRepository {
    var fetchDailyMoviesCallCount = 0
    var fetchWeekDaysMoviesCallCount = 0
    var fetchWeekEndMoviesCallCount = 0
    var fetchMovieDetailCallCount = 0
    
    
    func fetchDailyMovies(date: String) -> Observable<[MovieCellData]> {
        return Observable.create { emitter in
            Thread.sleep(forTimeInterval: 0.1)
            self.fetchDailyMoviesCallCount += 1
            if date == "invalid" {
                emitter.onError(MovieRepositoryMockError.unknown)
            } else {
                emitter.onNext(Array(repeating: MovieCellData.stub(), count: 10))
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchWeekDaysMovies(date: String) -> Observable<[MovieCellData]> {
        return Observable.create { emitter in
            Thread.sleep(forTimeInterval: 0.1)
            self.fetchWeekDaysMoviesCallCount += 1
            if date == "invalid" {
                emitter.onError(MovieRepositoryMockError.unknown)
            } else {
                emitter.onNext(Array(repeating: MovieCellData.stub(), count: 10))
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchWeekEndMovies(date: String) -> Observable<[MovieCellData]> {
        return Observable.create { emitter in
            Thread.sleep(forTimeInterval: 0.1)
            self.fetchWeekEndMoviesCallCount += 1
            if date == "invalid" {
                emitter.onError(MovieRepositoryMockError.unknown)
            } else {
                emitter.onNext(Array(repeating: MovieCellData.stub(), count: 10))
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchMovieDetail(movieCellData: MovieCellData) -> Observable<MovieDetailData> {
        return Observable.create { emitter in
            Thread.sleep(forTimeInterval: 0.1)
            self.fetchMovieDetailCallCount += 1
            if movieCellData.title == "invalid" {
                emitter.onError(MovieRepositoryMockError.unknown)
            } else {
                let movieDetailData = MovieDetailData.union(
                    firstData: movieCellData,
                    secondData: MovieDetailData.stub()
                )
                emitter.onNext(movieDetailData)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}

enum MovieRepositoryMockError: LocalizedError {
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "알 수 없는 에러 발생"
        }
    }
}
