//
//  SearchMoviePosterAPI.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

struct SearchMoviePosterAPI: API {
    typealias ResponseType = MoviePosterResponseDTO

    var configuration: APIConfiguration

    init(movieTitle: String, year: String? = nil) {
        if let year = year {
            self.configuration = APIConfiguration(
                baseUrl: .naver,
                param: ["query": movieTitle,
                        "display": "1",
                        "yearfrom": year, // 개봉년도
                        "yearto": year],
                hasHeader: true
            )
        } else {
            self.configuration = APIConfiguration(
                baseUrl: .naver,
                param: ["query": movieTitle,
                        "display": "1"],
                hasHeader: true
            )
        }
    }
}

