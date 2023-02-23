//
//  DailyBoxOfficeListResponseDTO+Mapping.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

struct DailyBoxOfficeListResponseDTO: Decodable {
    let boxOfficeResult: BoxOfficeResult
    
    struct BoxOfficeResult: Decodable {
        let boxofficeType: String
        let showRange: String
        let yearWeekTime: String?
        let dailyBoxOfficeList: [BoxOffice]
    }
}
extension DailyBoxOfficeListResponseDTO.BoxOfficeResult {
    
    func toDomain() -> [MovieCellData] { // posterURL이 빠진 1차 모델 반환
        var movieList = [MovieCellData]()
        
        for movie in dailyBoxOfficeList {
            let movieCellData = movie.toDomain()
            movieList.append(movieCellData)
        }
        return movieList
    }
}
