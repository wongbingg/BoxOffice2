//
//  SearchMovieDetailUseCase.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import RxSwift

protocol SearchMovieDetailUseCase {
    func execute(movie: MovieCellData) -> Observable<MovieDetailData>
}

struct DefaultSearchMovieDetailUseCase: SearchMovieDetailUseCase {
    let movieRepository: MovieRepository
    
    func execute(movie: MovieCellData) -> Observable<MovieDetailData> {
        
        return Observable.create { emitter in
            movieRepository.fetchMovieDetail(movieCellData: movie)
                .subscribe { movieDetail in
                    emitter.onNext(movieDetail)
                } onError: { error in
                    emitter.onError(error)
                }
        }
    }
}
