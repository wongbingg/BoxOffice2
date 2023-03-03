//
//  HeaderView.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    private let sectionHeaderlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.preferredFont(for: .headline, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionHeaderlabel)
        NSLayoutConstraint.activate([
            sectionHeaderlabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),
            sectionHeaderlabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeaderViewTitle(text: String) {
        sectionHeaderlabel.text = text
    }
}
