//
//  APIConfiguration.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

enum HTTPMethod {
    static let get = "GET"
}

enum BaseURL: String {
    case kobis = "https://www.kobis.or.kr/kobisopenapi/webservice/rest"
    case naver = "https://openapi.naver.com/v1/search/movie.json"
}

enum URLPath: String {
    case dailyBoxOffice = "/boxoffice/searchDailyBoxOfficeList.json"
    case weeklyBoxOffice = "/boxoffice/searchWeeklyBoxOfficeList.json"
    case movieInfo = "/movie/searchMovieInfo.json"
    case empty = ""
}

struct APIConfiguration {
    private let baseUrl: String
    private let paramList: [URLQueryItem]
    private let path: String
    private let httpMethod: String
    private let hasHeader: Bool
    
    init(
        baseUrl: BaseURL,
        param: [String : Any],
        path: URLPath = URLPath.empty,
        httpMethod: String = HTTPMethod.get,
        hasHeader: Bool = false
    ) {
        self.baseUrl = baseUrl.rawValue
        self.paramList = param.queryItems
        self.path = path.rawValue
        self.httpMethod = httpMethod
        self.hasHeader = hasHeader
    }
    
    func makeURLRequest() -> URLRequest? {
        guard var urlComponent = URLComponents(string: baseUrl + path) else { return nil }
        urlComponent.queryItems = paramList
        guard let url = urlComponent.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if hasHeader {
            request.setValue(
                Bundle.main.naver_Client_ID,
                forHTTPHeaderField: "X-Naver-Client-Id"
            )
            request.setValue(
                Bundle.main.naver_Client_Secret,
                forHTTPHeaderField: "X-Naver-Client-Secret"
            )
            return request
        } else {
            return request
        }
    }
}
