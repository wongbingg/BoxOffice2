//
//  MoviePosterResponseDTO+Mapping.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

struct MoviePosterResponseDTO: Decodable {
    let items: [Item]
    
    func posterURLString() -> String {
        let posterURL = items[0].image
        return posterURL
    }
}

struct Item: Decodable {
    let title: String
    let link: String
    let image: String
    let subtitle: String
    let pubDate: String
    let director: String
    let actor: String
    let userRating: String
}
