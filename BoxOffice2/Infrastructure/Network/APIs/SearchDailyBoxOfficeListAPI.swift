//
//  SearchDailyBoxOfficeListAPI.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

struct SearchDailyBoxOfficeListAPI: API {
    typealias ResponseType = DailyBoxOfficeListResponseDTO
    
    var configuration: APIConfiguration
    
    init(date: String, itemPerPage: String = "10") {
        self.configuration = APIConfiguration(
            baseUrl: .kobis,
            param: ["key": Bundle.main.kobisApiKey,
                    "targetDt": date,
                    "wideAreaCd": "0105001",
                    "itemPerPage": itemPerPage],
            path: .dailyBoxOffice
        )
    }
}
