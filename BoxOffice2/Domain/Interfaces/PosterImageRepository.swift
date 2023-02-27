//
//  PosterImageRepository.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/26.
//

import RxSwift
import UIKit

protocol PosterImageRepository {
    func fetchPosterImage(with title: String, year: String?) -> Observable<UIImage?>
}
