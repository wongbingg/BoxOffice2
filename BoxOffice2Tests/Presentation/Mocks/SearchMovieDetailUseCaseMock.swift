//
//  SearchMovieDetailUseCaseMock.swift
//  BoxOffice2Tests
//
//  Created by 이원빈 on 2023/02/27.
//

@testable import BoxOffice2
import RxSwift

final class SearchMovieDetailUseCaseMock: SearchMovieDetailUseCase {
    var callCount = 0
    private let movieReopsitory = MovieRepositoryMock()
    
    func execute(movie: MovieCellData) -> Observable<MovieDetailData> {
        callCount += 1
        return movieReopsitory.fetchMovieDetail(movieCellData: movie)
    }
}
