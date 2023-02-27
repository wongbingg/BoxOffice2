//
//  MovieDetailViewModelTests.swift
//  BoxOffice2Tests
//
//  Created by 이원빈 on 2023/02/27.
//

import XCTest
@testable import BoxOffice2

final class MovieDetailViewModelTests: XCTestCase {
    var sut: MovieDetailViewModel!
    var searchMovieDetailUseCase: SearchMovieDetailUseCaseMock!

    override func setUpWithError() throws {
        let actions = MovieDetailViewModelActions()
        searchMovieDetailUseCase = SearchMovieDetailUseCaseMock()
        sut = DefaultMovieDetailViewModel(
            actions: actions,
            movieCellData: MovieCellData.stub(),
            searchMovieDetailUseCase: searchMovieDetailUseCase
        )
    }

    override func tearDownWithError() throws {
        searchMovieDetailUseCase = nil
        sut = nil
    }
    
    func test_fetchMovieDetailData를실행하면_SearchMovieDetailUseCase가_실행되는지() {
        // given
        let expectation = XCTestExpectation(description: "CallCount")
        let expectCallCount = 1
        // when
        _ = sut.fetchMovieDetailData()
            .subscribe { movieDetail in
                expectation.fulfill()
            }
        // then
        XCTAssertEqual(expectCallCount, searchMovieDetailUseCase.callCount)
    }
}
