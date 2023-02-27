//
//  SearchDailyBoxOfficeUseCaseMock.swift
//  BoxOffice2Tests
//
//  Created by 이원빈 on 2023/02/27.
//

@testable import BoxOffice2
import RxSwift

final class SearchDailyBoxOfficeUseCaseMock: SearchDailyBoxOfficeUseCase {
    var callCount = 0
    private let movieReopsitory = MovieRepositoryMock()
    
    func execute(date: String) -> Observable<[MovieCellData]> {
        callCount += 1
        return movieReopsitory.fetchDailyMovies(date: date)
    }
}
