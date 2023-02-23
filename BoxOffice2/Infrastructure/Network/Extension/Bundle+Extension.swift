//
//  Bundle+Extension.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

extension Bundle {
    var naver_Client_ID: String {
        guard let file = self.path(forResource: "MovieInfo", ofType: "plist") else {
            return ""
        }
        guard let resource = NSDictionary(contentsOfFile: file) else {
            return ""
        }
        guard let key = resource["Naver_Client_ID"] as? String else {
            fatalError("Movie.plist에 Naver_Client_ID 값을 입력 해주세요.")
        }
        return key
    }
    
    var naver_Client_Secret: String {
        guard let file = self.path(forResource: "MovieInfo", ofType: "plist") else {
            return ""
        }
        guard let resource = NSDictionary(contentsOfFile: file) else {
            return ""
        }
        guard let key = resource["Naver_Client_Secret"] as? String else {
            fatalError("Movie.plist에 Naver_Client_Secret 값을 입력 해주세요.")
        }
        return key
    }
    
    var kobisApiKey: String {
        guard let file = self.path(forResource: "MovieInfo", ofType: "plist") else {
            return ""
        }
        guard let resource = NSDictionary(contentsOfFile: file) else {
            return ""
        }
        guard let key = resource["kobis_API_KEY"] as? String else {
            fatalError("Movie.plist에 kobis_API_KEY 값을 입력 해주세요.")
        }
        return key
    }
}
