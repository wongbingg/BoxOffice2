//
//  SearchMovieDetailUseCase.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//


protocol SearchMovieDetailUseCase {
    func execute() -> MovieDetailData
}

struct DefaultSearchMovieDetailUseCase: SearchMovieDetailUseCase {
    let movieRepository: MovieRepository
    
    func execute() -> MovieDetailData {
        return movieRepository.fetchMovieDetail()
    }
}
