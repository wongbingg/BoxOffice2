//
//  String+Extension.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/26.
//

import Foundation

extension String {
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
    
    func toDecimal() -> String {
        guard let number = Int(self) else { return "" }
        return numberFormatter.string(from: NSNumber(integerLiteral: number)) ?? ""
    }
    
    func localized(bundle: Bundle = .main,
                   tableName: String = "Localizable") -> String {
        return NSLocalizedString(
            self,
            tableName: tableName,
            value: "**\(self)**",
            comment: ""
        )
    }
}

extension String: Entity {}
