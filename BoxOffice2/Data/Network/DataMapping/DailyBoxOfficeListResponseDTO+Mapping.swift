//
//  DailyBoxOfficeListResponseDTO+Mapping.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

struct DailyBoxOfficeListResponseDTO: DTO {
    typealias T = Array<MovieCellData>
    
    let boxOfficeResult: BoxOfficeResult
    
    func toDomain() -> [MovieCellData] {
        boxOfficeResult.toDomain()
    }
    
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
            let movieData = movie.toDomain()
            movieList.append(movieData)
        }
        return movieList
    }
}
