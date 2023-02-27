//
//  DefaultMovieRepository.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation
import RxSwift

final class DefaultMovieRepository: MovieRepository {
    private let disposeBag = DisposeBag()
    
    func fetchDailyMovies(date: String) -> Observable<[MovieCellData]> {
        let api = SearchDailyBoxOfficeListAPI(date: date)
        
        return Observable.create { emitter in
            self.search(date: date, with: api)
                .subscribe { movies in
                    emitter.onNext(movies)
                } onError: { error in
                    emitter.onError(error)
                } onCompleted: {
                    emitter.onCompleted()
                }
        }
    }
    
    func fetchWeekDaysMovies(date: String) -> Observable<[MovieCellData]> {
        let api = SearchWeeklyBoxOfficeListAPI(date: date, weekOption: .weekDays)
        
        return Observable.create { emitter in
            self.search(date: date, with: api)
                .subscribe { movies in
                    emitter.onNext(movies)
                } onError: { error in
                    emitter.onError(error)
                } onCompleted: {
                    emitter.onCompleted()
                }
        }
    }
    
    func fetchWeekEndMovies(date: String) -> Observable<[MovieCellData]> {
        let api = SearchWeeklyBoxOfficeListAPI(date: date, weekOption: .weekEnd)
        
        return Observable.create { emitter in
            self.search(date: date, with: api)
                .subscribe { movies in
                    emitter.onNext(movies)
                } onError: { error in
                    emitter.onError(error)
                } onCompleted: {
                    emitter.onCompleted()
                }
        }
    }
    
    func fetchMovieDetail(movieCellData: MovieCellData) -> Observable<MovieDetailData> {
        let api = SearchMovieInfoAPI(movieCode: movieCellData.movieCode)
        
        return Observable.create { emitter in
            api.execute().subscribe(
                onNext: { response in
                    let movieDetailData = response.toDomain()
                    let movie = MovieDetailData.union(
                        firstData: movieCellData,
                        secondData: movieDetailData
                    )
                    emitter.onNext(movie)
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
        }
    }
    
    private func search(date: String, with api: some API) -> Observable<[MovieCellData]> {
        
        return Observable.create { emitter in
            api.execute().subscribe { dto in
                let movieDatas = dto.toDomain() as! [MovieCellData]
                emitter.onNext(movieDatas)
                emitter.onCompleted()
            } onError: { error in
                emitter.onError(error)
            }
        }
    }
    
    private func fetchMoviePosterURL(with movieName: String, year: String) -> Observable<String> {
        
        let api = SearchMoviePosterAPI(movieTitle: movieName, year: year)

        return Observable.create { emitter in
            api.execute().subscribe(
                onNext: { response in
                    emitter.onNext(response.toDomain())
                    emitter.onCompleted()
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
        }
    }
}
