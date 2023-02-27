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

extension Array<MovieCellData>: Entity {}
