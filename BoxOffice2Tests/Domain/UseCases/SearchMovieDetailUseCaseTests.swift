//
//  SearchMovieDetailUseCaseTests.swift
//  BoxOffice2Tests
//
//  Created by 이원빈 on 2023/02/27.
//

import XCTest
@testable import BoxOffice2

final class SearchMovieDetailUseCaseTests: XCTestCase {
    var movieRepository: MovieRepositoryMock!
    var sut: SearchMovieDetailUseCase!

    override func setUpWithError() throws {
        movieRepository = MovieRepositoryMock()
        sut = DefaultSearchMovieDetailUseCase(
            movieRepository: movieRepository
        )
    }

    override func tearDownWithError() throws {
        movieRepository = nil
        sut = nil
    }
    
    func test_UseCase를실행하면_repository의_fetchWeekEndMovies가호출되는지() {
        // given
        let expectation = XCTestExpectation(description: "CallCountTest")
        let expectationCallCount = 1
        
        // when
        _ = sut.execute(movie: MovieCellData.stub())
            .subscribe { _ in
                
            } onError: { _ in
                
            } onCompleted: {
                expectation.fulfill()
            }

        // then
        XCTAssertEqual(expectationCallCount,
                       movieRepository.fetchMovieDetailCallCount)
    }
    
    func test_UseCase를실행하면_MovieCellData와병합된모델이_반환되는지() {
        // given
        let expectation = XCTestExpectation(description: "반환값테스트")
        let uuid = "uuid"
        let currentRank = "1"
        let title = "테스트"
        let openDate = "20201010"
        
        // when
        _ = sut.execute(movie: MovieCellData.stub(
            uuid: uuid,
            currentRank: currentRank,
            title: title,
            openDate: openDate)
        )
            .subscribe { movieDetail in
                expectation.fulfill()
                
                // then
                XCTAssertEqual(uuid, movieDetail.uuid)
                XCTAssertEqual(currentRank, movieDetail.currentRank)
                XCTAssertEqual(title, movieDetail.title)
                XCTAssertEqual(openDate, movieDetail.openDate)
            }
    }
    
    func test_지정한오류를_반환하는지() {
        // given
        let expectation = XCTestExpectation(description: "오류반환")
        let expectationError = MovieRepositoryMockError.unknown
        
        // when
        _ = sut.execute(movie: MovieCellData.stub(title: "invalid"))
            .subscribe { movieCellDatas in
                //
            } onError: { error in
                // then
                expectation.fulfill()
                XCTAssertEqual(expectationError, error as! MovieRepositoryMockError)
            }
    }
}
