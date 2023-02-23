//
//  WeeklyBoxOfficeListResponseDTO+Mapping.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

struct WeeklyBoxOfficeListResponseDTO: Decodable {
    let boxOfficeResult: BoxOfficeResult
    
    struct BoxOfficeResult: Decodable {
        let boxofficeType: String
        let showRange: String
        let yearWeekTime: String?
        let weeklyBoxOfficeList: [BoxOffice]
    }
}

struct BoxOffice: Decodable {
    let rnum: String
    let rank: String
    let rankInten: String
    let rankOldAndNew: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let salesAmt: String
    let salesShare: String
    let salesInten: String
    let salesChange: String
    let salesAcc: String
    let audiCnt: String
    let audiInten: String
    let audiChange: String
    let audiAcc: String
    let scrnCnt: String
    let showCnt: String
    
    func toDomain() -> MovieCellData {
        .init(
            uuid: UUID().uuidString,
            movieCode: movieCd,
            posterURL: "",
            currentRank: rank,
            title: movieNm,
            openDate: openDt,
            totalAudience: audiCnt,
            rankChange: rankInten,
            isNewEntry: rankOldAndNew == "NEW"
        )
    }
    
    func toDetailDomain() -> MovieDetailData {
        .init(
            uuid: UUID().uuidString,
            posterURL: "",
            currentRank: rank,
            title: movieNm,
            openDate: openDt,
            totalAudience: audiCnt,
            rankChange: rankInten,
            isNewEntry: rankOldAndNew == "NEW",
            productionYear: "",
            openYear: "",
            showTime: "",
            genreName: "",
            directorName: "",
            actors: [],
            ageLimit: ""
        )
    }
}


extension WeeklyBoxOfficeListResponseDTO.BoxOfficeResult {
    
    func toDomain() -> [MovieCellData] { // posterURL이 빠진 1차 모델 반환
        var movieList = [MovieCellData]()
        
        for movie in weeklyBoxOfficeList {
            let movieCellData = movie.toDomain()
            movieList.append(movieCellData)
        }
        return movieList
    }
}
