//
//  SearchDailyBoxOfficeUseCaseTests.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/27.
//

import XCTest
@testable import BoxOffice2

final class SearchDailyBoxOfficeUseCaseTests: XCTestCase {
    var movieRepository: MovieRepositoryMock!
    var sut: SearchDailyBoxOfficeUseCase!

    override func setUpWithError() throws {
        movieRepository = MovieRepositoryMock()
        sut = DefaultSearchDailyBoxOfficeUseCase(
            movieRepository: movieRepository
        )
    }

    override func tearDownWithError() throws {
        movieRepository = nil
        sut = nil
    }
    
    func test_UseCase를실행하면_repository의_fetchDailyMovies가호출되는지() {
        // given
        let expectation = XCTestExpectation(description: "CallCountTest")
        let expectationCallCount = 1
        
        // when
        _ = sut.execute(date: "20201212")
            .subscribe { _ in
                
            } onError: { _ in
                
            } onCompleted: {
                expectation.fulfill()
            }

        // then
        XCTAssertEqual(expectationCallCount,
                       movieRepository.fetchDailyMoviesCallCount)
    }
    
    func test_지정한오류를_반환하는지() {
        // given
        let expectation = XCTestExpectation(description: "오류반환")
        let expectationError = MovieRepositoryMockError.unknown
        
        // when
        _ = sut.execute(date: "invalid")
            .subscribe { movieCellDatas in
                //
            } onError: { error in
                // then
                expectation.fulfill()
                XCTAssertEqual(expectationError, error as! MovieRepositoryMockError)
            }
    }
}
