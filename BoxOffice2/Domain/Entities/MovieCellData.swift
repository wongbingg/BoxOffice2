//
//  MovieCellData.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

struct MovieCellData {
    let uuid: String
    var posterURL: String
    let currentRank: String
    let title: String
    let openDate: String
    let totalAudience: String
    let rankChange: String
    let isNewEntry: Bool
    let movieCode: String
    
    mutating func setPosterURL(with url: String) {
        posterURL = url
    }
}
