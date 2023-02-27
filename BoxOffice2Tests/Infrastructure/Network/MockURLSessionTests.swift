//
//  MockURLSessionTests.swift
//  BoxOffice2Tests
//
//  Created by 이원빈 on 2023/02/27.
//

import XCTest
import RxSwift
@testable import BoxOffice2

final class MockURLSessionTests: XCTestCase {
    let api = MockAPI()
    
    func test_statusCode가200일때_반환값을넘겨주는지() {
        // given
        let expectation = XCTestExpectation(description: "successTest")
        let expectationData = "lee"
        var result = ""
        
        let mockResponse: MockURLSession.Response = {
            let data: Data? = try? JSONEncoder().encode(MockDTO(name: "lee"))
            let successResponse = HTTPURLResponse(url: URL(string: "www.naver.com")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        let mockURLSession = MockURLSession(response: mockResponse)
        let apiClient = APIClient(sesseion: mockURLSession)
        // when
        _ = api.execute(using: apiClient)
            .subscribe { dto in
                result = dto.toDomain()
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1.0)
        // then
        XCTAssertEqual(expectationData, result)
    }
    
    func test_statusCode가400일때_오류를반환하는지() {
        // given
        let expectation = XCTestExpectation(description: "failTest")
        let expectationError: APIError = .response(400)
        var resultError: APIError?
        
        let mockResponse: MockURLSession.Response = {
            let data: Data? = try? JSONEncoder().encode(MockDTO(name: "lee"))
            let successResponse = HTTPURLResponse(url: URL(string: "www.naver.com")!,
                                                  statusCode: 400,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (data: data, urlResponse: successResponse, error: nil)
        }()
        let mockURLSession = MockURLSession(response: mockResponse)
        let apiClient = APIClient(sesseion: mockURLSession)
        // when
        _ = api.execute(using: apiClient)
            .subscribe { _ in
                
            } onError: { error in
                resultError = error as? APIError
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 1.0)
        // then
        XCTAssertEqual(expectationError, resultError)
    }
}

struct MockAPI: API {
    typealias ResponseType = MockDTO
    
    var configuration: APIConfiguration
    
    init() {
        configuration = APIConfiguration(
            baseUrl: .kobis,
            param: ["d":"sd"],
            path: .empty
        )
    }
}

struct MockDTO: Codable, DTO {
    typealias T = String
    let name: String
    
    func toDomain() -> String {
        return name
    }
}
