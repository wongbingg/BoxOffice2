//
//  SearchMoviesUseCase.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

protocol SearchMoviesUseCase {
    func execute() -> [MovieCellData]
}

struct DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    let movieRepository: MovieRepository
    
    func execute() -> [MovieCellData] {
        return movieRepository.fetchMovies()
    }
}
