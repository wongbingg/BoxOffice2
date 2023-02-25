//
//  MovieMainInfoCollectionViewCell.swift
//  BoxOffice
//
//  Created by Judy on 2023/01/05.
//

import UIKit
import RxSwift

final class MovieMainInfoView: UIView {
    private let imageCacheManager = DefaultImageCacheManager()
    private let disposeBag = DisposeBag()
    
    private let rankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let openYearStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .top
        stackView.setContentHuggingPriority(UILayoutPriority(200), for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.setContentCompressionResistancePriority(UILayoutPriority(900), for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let starView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let rankChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.layer.backgroundColor = UIColor.systemGreen.cgColor
        label.layer.cornerRadius = 5
        return label
    }()
    
    private let isNewEntryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.layer.backgroundColor = UIColor.systemYellow.cgColor
        label.layer.cornerRadius = 5
        return label
    }()
    
    private let rankBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    private let currentRanklabel = MovieLabel(font: .largeTitle, isBold: true)
    private let titleLabel = MovieLabel(font: .title1, isBold: true)
    private let openYearLabel = MovieLabel(font: .body)
    private let genreLabel = MovieLabel(font: .body)
    private let ratingLabel = MovieLabel(font: .largeTitle)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        let separator = UIBezierPath()
        separator.move(to: CGPoint(x: 0, y: bounds.maxY))
        separator.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        separator.lineWidth = 8
        UIColor.systemGray5.setStroke()
        separator.stroke()
        separator.close()
    }
    
    func configure(with movie: MovieDetailData, rating: String) {
        ratingLabel.text = rating == "nan" ? "정보 없음" : rating
        titleLabel.text = movie.title
        currentRanklabel.text = movie.currentRank
        setRankChangeLabel(with: movie.rankChange)
        setIsNewEntryLabel(with: movie.isNewEntry)
        openYearLabel.text = movie.openYear + " • "
        genreLabel.text = movie.genreName
//        setupPosterImage(with: movie.posterURL)
        
        setPosterImageView(with: movie.title)
    }
    
    private func setRankChangeLabel(with rankChange: String) {
        if Int(rankChange) ?? 0 > 0 {
            rankChangeLabel.text = "  " + rankChange + "▲" + "  "
            rankChangeLabel.layer.backgroundColor = UIColor.systemGreen.cgColor
        } else if Int(rankChange) ?? 0 < 0 {
            rankChangeLabel.text = "  " + rankChange + "▼" + "  "
            rankChangeLabel.layer.backgroundColor = UIColor.systemRed.cgColor
        } else {
            rankChangeLabel.isHidden = true
        }
    }
    
    private func setIsNewEntryLabel(with isNewEntry: Bool) {
        if isNewEntry {
            isNewEntryLabel.text = " 신규진입 "
        } else {
            isNewEntryLabel.text = ""
        }
    }
    
    private func setupView() {
        addSubView()
        setupConstraint()
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority(900), for: .vertical)
        titleLabel.adjustsFontSizeToFitWidth = true
        currentRanklabel.textColor = .white
        self.backgroundColor = .systemBackground
    }
    
    private func setPosterImageView(with title: String){
        
        SearchMoviePosterAPI(movieTitle: title).execute()
            .observe(on: MainScheduler.instance)
            .subscribe { [self] response in
                let url = response.toDomain()
                guard let url = URL(string: url) else {
                    return
                }
                
                imageCacheManager.getImage(with: url)
                    .observe(on: MainScheduler.instance)
                    .subscribe { image in
                        guard let image = image else { return }
                        self.posterView.image = image
                        
                    } onError: { error in
                        print(error.localizedDescription)
                    }
                    .disposed(by: disposeBag)
                
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setupPosterImage(with url: String) {//
        guard let validUrl = URL(string: url) else {
            // 기본이미지
            return
        }
        imageCacheManager.getImage(with: validUrl)
            .subscribe { [self] image in
                guard let image = image else { return }
                posterView.image = image
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout Constraints
private extension MovieMainInfoView {
    
    func addSubView() {
        rankStackView.addArrangedSubview(rankChangeLabel)
        rankStackView.addArrangedSubview(isNewEntryLabel)
        
        openYearStackView.addArrangedSubview(openYearLabel)
        openYearStackView.addArrangedSubview(genreLabel)
        
        ratingStackView.addArrangedSubview(starView)
        ratingStackView.addArrangedSubview(ratingLabel)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(rankStackView)
        infoStackView.addArrangedSubview(openYearStackView)
        infoStackView.addArrangedSubview(ratingStackView)
        
        entireStackView.addArrangedSubview(posterView)
        entireStackView.addArrangedSubview(infoStackView)
        
        self.addSubview(entireStackView)
        addSubview(rankBackgroundView)
        rankBackgroundView.addSubview(currentRanklabel)
    }

    func setupConstraint() {
        NSLayoutConstraint.activate([
            currentRanklabel.centerXAnchor.constraint(equalTo: rankBackgroundView.centerXAnchor),
            currentRanklabel.centerYAnchor.constraint(equalTo: rankBackgroundView.centerYAnchor),
            
            rankBackgroundView.topAnchor.constraint(equalTo: posterView.topAnchor),
            rankBackgroundView.leadingAnchor.constraint(equalTo: posterView.leadingAnchor),
            rankBackgroundView.widthAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 0.2),
            rankBackgroundView.heightAnchor.constraint(equalTo: rankBackgroundView.widthAnchor),
            
            entireStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                 constant: 8),
            entireStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -8),
            entireStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                     constant: 16),
            entireStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -16),
            
            posterView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor,
                                              multiplier: 4/10),
            starView.widthAnchor.constraint(equalTo: starView.heightAnchor)
        ])
    }
}
