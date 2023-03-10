//
//  MovieDetailData.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

struct MovieDetailData: Entity {
    let uuid: String
    let currentRank: String
    let title: String
    let openDate: String
    let totalAudience: String
    let rankChange: String
    let isNewEntry: Bool
    let productionYear: String
    let openYear: String
    let showTime: String
    let genreName: String
    let directorName: String
    let actors: [String]
    let ageLimit: String
    let movieCode: String
}

extension MovieDetailData {
    static func union(firstData: MovieCellData,
                      secondData: MovieDetailData) -> MovieDetailData {
        .init(uuid: firstData.uuid,
              currentRank: firstData.currentRank,
              title: firstData.title,
              openDate: firstData.openDate,
              totalAudience: firstData.totalAudience,
              rankChange: firstData.rankChange,
              isNewEntry: firstData.isNewEntry,
              productionYear: secondData.productionYear,
              openYear: secondData.openYear,
              showTime: secondData.showTime,
              genreName: secondData.genreName,
              directorName: secondData.directorName,
              actors: secondData.actors,
              ageLimit: secondData.ageLimit,
              movieCode: firstData.movieCode)
        
        
    }
    static func stub(uuid: String = "" ,
                     currentRank: String = "",
                     title: String = "",
                     openDate: String = "",
                     totalAudience: String = "",
                     rankChange: String = "",
                     isNewEntry: Bool = false,
                     productionYear: String = "",
                     openYear: String = "",
                     showTime: String = "",
                     genreName: String = "",
                     directorName: String = "",
                     actors: [String] = [],
                     ageLimit: String = "",
                     movieCode: String = "") -> Self {
        .init(uuid: uuid,
              currentRank: currentRank,
              title: title,
              openDate: openDate,
              totalAudience: totalAudience,
              rankChange: rankChange,
              isNewEntry: isNewEntry,
              productionYear: productionYear,
              openYear: openYear,
              showTime: showTime,
              genreName: genreName,
              directorName: directorName,
              actors: actors,
              ageLimit: ageLimit,
              movieCode: movieCode)
    }
}

