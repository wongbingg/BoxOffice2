//
//  MockURLSession.swift
//  BoxOffice2Tests
//
//  Created by 이원빈 on 2023/02/27.
//

@testable import BoxOffice2
import Foundation

final class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        
        return MockURLSessionDataTask {
            
            completionHandler(self.response.data,
                              self.response.urlResponse,
                              self.response.error)
        }
    }
}

final class MockURLSessionDataTask: URLSessionDataTask {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    override func resume() {
        resumeHandler()
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
