//
//  MovieRepository.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

protocol MovieRepository {
    func fetchMovies() -> [MovieCellData]
    func fetchMovieDetail() -> MovieDetailData
}
