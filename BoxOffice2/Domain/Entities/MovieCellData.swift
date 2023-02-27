//
//  MovieCellData.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

struct MovieCellData: Entity, Hashable {
    let uuid: String
    let currentRank: String
    let title: String
    let openDate: String
    let totalAudience: String
    let rankChange: String
    let isNewEntry: Bool
    let movieCode: String
}

extension MovieCellData {
    static func stub(uuid: String = "",
                     currentRank: String = "",
                     title: String = "",
                     openDate: String = "",
                     totalAudience: String = "",
                     rankChange: String = "",
                     isNewEntry: Bool = false,
                     movieCode: String = "") -> Self {
        .init(uuid: uuid,
              currentRank: currentRank,
              title: title,
              openDate: openDate,
              totalAudience: totalAudience,
              rankChange: rankChange,
              isNewEntry: isNewEntry,
              movieCode: movieCode)
    }
}

extension Array<MovieCellData>: Entity {}
