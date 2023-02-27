//
//  HomeViewModelTests.swift
//  BoxOffice2Tests
//
//  Created by 이원빈 on 2023/02/27.
//

import XCTest
@testable import BoxOffice2

final class HomeViewModelTests: XCTestCase {
    var sut: HomeViewModel!
    var searchDailyBoxOfficeUseCase: SearchDailyBoxOfficeUseCaseMock!
    var searchWeekDaysBoxOfficeUseCase: SearchWeekDaysBoxOfficeUseCaseMock!
    var searchWeekEndBoxOfficeUseCase: SearchWeekEndBoxOfficeUseCaseMock!
    
    
    override func setUpWithError() throws {
        searchDailyBoxOfficeUseCase = SearchDailyBoxOfficeUseCaseMock()
        searchWeekDaysBoxOfficeUseCase = SearchWeekDaysBoxOfficeUseCaseMock()
        searchWeekEndBoxOfficeUseCase = SearchWeekEndBoxOfficeUseCaseMock()
        
        let actions = HomeViewModelActions { movieCellData in
            //
        }
        
        sut = DefaultHomeViewModel(
            actions: actions,
            searchDailyBoxOfficeUseCase: searchDailyBoxOfficeUseCase,
            searchWeekDaysBoxOfficeUseCase: searchWeekDaysBoxOfficeUseCase,
            searchWeekEndBoxOfficeUseCase: searchWeekEndBoxOfficeUseCase
        )
    }
    
    override func tearDownWithError() throws {
        searchDailyBoxOfficeUseCase = nil
        searchWeekDaysBoxOfficeUseCase = nil
        searchWeekEndBoxOfficeUseCase = nil
        sut = nil
    }
    
    func test_dailyData를_요청했을때_searchDailyBoxOfficeUseCase가실행되는지() {
        // given
        let expectationCount = 1
        // when
        sut.requestDailyData(with: "")
        // then
        XCTAssertEqual(expectationCount, searchDailyBoxOfficeUseCase.callCount)
    }
    
    func test_allWeekData를_요청했을때_searchWeekDaysBoxOfficeUseCase가실행되는지() {
        // given
        let expectationCount = 1
        // when
        sut.requestAllWeekData(with: "")
        // then
        XCTAssertEqual(expectationCount, searchWeekDaysBoxOfficeUseCase.callCount)
    }
    
    func test_weekEndData를_요청했을때_searchWeekEndBoxOfficeUseCase가실행되는지() {
        // given
        let expectationCount = 1
        // when
        sut.requestWeekEndData(with: "")
        // then
        XCTAssertEqual(expectationCount, searchWeekEndBoxOfficeUseCase.callCount)
    }
    
    func test_dailyData를_요청했을때_viewModel의_dailyBoxOffices프로퍼티에값이들어가는지() {
        // given
        let expectation = XCTestExpectation(description: "반환값 테스트")
        let expectationCount = 10
        var resultCount = 0
        _ = sut.dailyBoxOffices.subscribe { movieCellDatas in
            resultCount = movieCellDatas.count
            expectation.fulfill()
        }
        // when
        sut.requestDailyData(with: "")
        // then
        XCTAssertEqual(expectationCount, resultCount)
    }
    
    func test_allWeekData를_요청했을때_viewModel의_allWeekBoxOffices프로퍼티에값이들어가는지() {
        // given
        let expectation = XCTestExpectation(description: "반환값 테스트")
        let expectationCount = 10
        var resultCount = 0
        _ = sut.allWeekBoxOffices.subscribe { movieCellDatas in
            resultCount = movieCellDatas.count
            expectation.fulfill()
        }
        // when
        sut.requestAllWeekData(with: "")
        // then
        XCTAssertEqual(expectationCount, resultCount)
    }
    
    func test_weekEndData를_요청했을때_viewModel의_weekEndBoxOffices프로퍼티에값이들어가는지() {
        // given
        let expectation = XCTestExpectation(description: "반환값 테스트")
        let expectationCount = 10
        var resultCount = 0
        _ = sut.weekEndBoxOffices.subscribe { movieCellDatas in
            resultCount = movieCellDatas.count
            expectation.fulfill()
        }
        // when
        sut.requestWeekEndData(with: "")
        // then
        XCTAssertEqual(expectationCount, resultCount)
    }
}
