//
//  DTO.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

protocol DTO: Decodable {
    associatedtype T: Entity
    func toDomain() -> T
}
