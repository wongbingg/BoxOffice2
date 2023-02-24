//
//  MovieRepository.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import RxSwift

protocol MovieRepository {
    func fetchDailyMovies(date: String) -> Observable<[MovieCellData]>
    func fetchWeekDaysMovies(date: String) -> Observable<[MovieCellData]>
    func fetchWeekEndMovies(date: String) -> Observable<[MovieCellData]>
    func fetchMovieDetail(movieCellData: MovieCellData) -> Observable<MovieDetailData>
}
