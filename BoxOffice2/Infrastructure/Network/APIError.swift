//
//  APIError.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

enum APIError: LocalizedError, Equatable {
    case unknown
    case response(Int)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error has occured."
        case .response(let code):
            return "현재 코드: \(code) \n 서버코드가 200~300 범위를 넘었습니다. 요청이 잘못되었습니다."
        }
    }
}
