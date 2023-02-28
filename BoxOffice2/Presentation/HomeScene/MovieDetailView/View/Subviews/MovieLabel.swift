//
//  MovieLabel.swift
//  BoxOffice2
//
//  Created by Judy on 2023/02/24.
//

import UIKit

final class MovieLabel: UILabel {
    init(font: UIFont.TextStyle, isBold: Bool = false, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = .preferredFont(forTextStyle: font)
        self.adjustsFontForContentSizeCategory = true
        if isBold {
            self.font = .boldSystemFont(ofSize: self.font.pointSize)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
