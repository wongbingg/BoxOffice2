//
//  MovieDetailInfoResponseDTO+Mapping.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

struct MovieDetailInfoResponseDTO: Decodable {
    let movieInfoResult: MovieInfoResult
}

extension MovieDetailInfoResponseDTO {
    
    struct MovieInfoResult: Decodable {
        let movieInfo: MovieInfo
    }
    
    struct MovieInfo: Decodable {
        let movieCd: String
        let movieNm: String
        let movieNmEn: String
        let movieNmOg: String
        let showTm: String
        let prdtYear: String
        let openDt: String
        let prdtStatNm: String
        let typeNm: String
        let nations: [Nation]
        let genres: [Genre]
        let directors: [Director]
        let actors: [Actor]
        let showTypes: [ShowType]
        let companys: [Company]
        let audits: [Audit]
        let staffs: [Staff]
    }
    
    struct Nation: Decodable {
        let nationNm: String
    }

    struct Genre: Decodable {
        let genreNm: String
    }

    struct Director: Decodable {
        let peopleNm: String
        let peopleNmEn: String
    }

    struct Actor: Decodable {
        let peopleNm: String
        let peopleNmEn: String
        let cast: String
        let castEn: String
        
        func toDomain() -> String {
            return peopleNm
        }
    }

    struct ShowType: Decodable {
        let showTypeGroupNm: String
        let showTypeNm: String
    }

    struct Company: Decodable {
        let companyCd: String
        let companyNm: String
        let companyNmEn: String
        let companyPartNm: String
    }

    struct Audit: Decodable {
        let auditNo: String
        let watchGradeNm: String
        
        func toDomain() -> String {
            return watchGradeNm
        }
    }

    struct Staff: Decodable {
        let peopleNm: String
        let peopleNmEn: String
        let staffRoleNm: String
    }
}

extension MovieDetailInfoResponseDTO.MovieInfo { // 일반 조회에서 얻은 모델을 파라미터로 삽입
    
    func toDomain(with firstModel: MovieDetailData) -> MovieDetailData {
        .init(
            uuid: UUID().uuidString,
            posterURL: "",
            currentRank: firstModel.currentRank,
            title: firstModel.title,
            openDate: firstModel.openDate,
            totalAudience: firstModel.totalAudience,
            rankChange: firstModel.rankChange,
            isNewEntry: firstModel.isNewEntry,
            productionYear: prdtYear,
            openYear: String(openDt.prefix(4)),
            showTime: showTm,
            genreName: genres[0].genreNm,
            directorName: directors[0].peopleNm,
            actors: actors.map { $0.toDomain() },
            ageLimit: audits[0].toDomain()
        )
    }
    
    func fetchMovieCode() -> String {
        return movieCd
    }
}
