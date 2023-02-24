//
//  SearchWeeklyBoxOfficeListAPI.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

enum WeekOption: String {
    case allWeek = "0"
    case weekEnd = "1"
    case weekDays = "2"
}

struct SearchWeeklyBoxOfficeListAPI: API {
    typealias ResponseType = WeeklyBoxOfficeListResponseDTO
    
    var configuration: APIConfiguration
    
    init(date: String, itemPerPage: String = "10", weekOption: WeekOption) {
        
        self.configuration = APIConfiguration(
            baseUrl: .kobis,
            param: ["key": Bundle.main.kobisApiKey,
                    "targetDt": date,
                    "weekGb": weekOption.rawValue,
                    "wideAreaCd": "0105001",
                    "itemPerPage": itemPerPage],
            path: .weeklyBoxOffice
        )
    }
}
