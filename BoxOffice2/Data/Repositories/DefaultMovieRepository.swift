//
//  DefaultMovieRepository.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation
import RxSwift

final class DefaultMovieRepository: MovieRepository {
    private enum Mode {
        case daily
        case weekDays
        case weekEnd
    }
    
    private let disposeBag = DisposeBag()
    
    func fetchDailyMovies(date: String) -> Observable<[MovieCellData]> {
        
        return Observable.create { [self] emitter in
            searchDailyBoxOffice(date: date)
                .subscribe { movies in
                    emitter.onNext(movies)
                } onError: { error in
                    emitter.onError(error)
                }
        }
    }
    
    private func searchDailyBoxOffice(date: String) -> Observable<[MovieCellData]> {
        let api = SearchDailyBoxOfficeListAPI(date: date)
        
        return Observable.create { emitter in
            api.execute().subscribe(
                onNext: { [self] response in
                    var movieDatas = response.toDomain()
                    for (index, movieCell) in movieDatas.enumerated() {
                        fetchMoviePosterURL(
                            with: movieCell.title,
                            openYear: String(movieCell.openDate.prefix(4))
                        ).subscribe { posterURL in
                            movieDatas[index].setPosterURL(with: posterURL)
                        } onError: { error in
                            emitter.onError(error)
                        }.disposed(by: disposeBag)
                    }
                    emitter.onNext(movieDatas)
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
        }
    }
    
    func fetchWeekDaysMovies(date: String) -> Observable<[MovieCellData]> {
        let api = SearchWeeklyBoxOfficeListAPI(date: date, weekOption: .weekDays)
        
        return Observable.create { emitter in
            api.execute().subscribe(
                onNext: { [self] response in
                    var movieDatas = response.toDomain()
                    for (index, movieCell) in movieDatas.enumerated() {
                        fetchMoviePosterURL(
                            with: movieCell.title,
                            openYear: String(movieCell.openDate.prefix(4))
                        ).subscribe { posterURL in
                            movieDatas[index].setPosterURL(with: posterURL)
                        } onError: { error in
                            emitter.onError(error)
                        }.disposed(by: disposeBag)
                    }
                    emitter.onNext(movieDatas)
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
        }
    }
    
    func fetchWeekEndMovies(date: String) -> Observable<[MovieCellData]> {
        let api = SearchWeeklyBoxOfficeListAPI(date: date, weekOption: .weekDays)
        
        return Observable.create { emitter in
            api.execute().subscribe(
                onNext: { [self] response in
                    var movieDatas = response.toDomain()
                    for (index, movieCell) in movieDatas.enumerated() {
                        fetchMoviePosterURL(
                            with: movieCell.title,
                            openYear: String(movieCell.openDate.prefix(4))
                        ).subscribe { posterURL in
                            movieDatas[index].setPosterURL(with: posterURL)
                        } onError: { error in
                            emitter.onError(error)
                        }.disposed(by: disposeBag)
                    }
                    emitter.onNext(movieDatas)
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
        }
    }
    
    func fetchMovieDetail(movieData: MovieCellData) -> Observable<MovieDetailData> {
        let api = SearchMovieInfoAPI(movieCode: movieData.movieCode)
        
        return Observable.create { emitter in
            api.execute().subscribe(
                onNext: { response in
                    let movie = response.toDomain(with: movieData)
                    emitter.onNext(movie)
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
        }
    }
    
    private func fetchMoviePosterURL(with movieName: String,
                                     openYear: String) -> Observable<String> {
        
        let api = SearchMoviePosterAPI(movieTitle: movieName, year: openYear)

        return Observable.create { emitter in
            api.execute().subscribe(
                onNext: { response in
                    emitter.onNext(response.posterURLString())
                },
                onError: { error in
                    emitter.onError(error)
                }
            )
        }
    }
}
