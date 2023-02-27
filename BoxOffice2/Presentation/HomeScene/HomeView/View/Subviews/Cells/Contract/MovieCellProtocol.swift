//
//  MovieCellProtocol.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/27.
//

import UIKit

protocol MovieCellProtocol: AnyObject {
    func setup(with data: MovieCellData)
    func setPosterImageView(with image: UIImage)
    func stopActivityIndicator()
}
