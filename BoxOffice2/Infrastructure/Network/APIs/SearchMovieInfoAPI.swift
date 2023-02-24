//
//  SearchMovieInfoAPI.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

struct SearchMovieInfoAPI: API {
    typealias ResponseType = MovieDetailInfoResponseDTO
    
    var configuration: APIConfiguration
    
    init(movieCode: String) {
        self.configuration = APIConfiguration(
            baseUrl: .kobis,
            param: ["key": Bundle.main.kobisApiKey,
                    "movieCd": movieCode],
            path: .movieInfo
        )
    }
}

