//
//  Dictionary+Extension.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import Foundation

extension Dictionary {
    var queryItems: [URLQueryItem] {
        var itemList = [URLQueryItem]()
        for (key, value) in self {
            guard let key = key as? String, let value = value as? String else { break }
            itemList.append(URLQueryItem(name: key, value: value))
        }
        return itemList
    }
}
