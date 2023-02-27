//
//  GridCell.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit
import RxSwift

final class GridCell: UICollectionViewCell, MovieCellProtocol {
    private let disposeBag = DisposeBag()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.tintColor = .systemBlue
        indicator.style = .medium
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemGray3
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.setContentHuggingPriority(UILayoutPriority(100), for: .vertical)
        return label
    }()
    
    private let badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let rankChangeBadgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.layer.backgroundColor = UIColor.systemGreen.cgColor
        label.layer.cornerRadius = 5
        return label
    }()
    
    private let newEntryBadgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.layer.backgroundColor = UIColor.systemYellow.cgColor
        label.layer.cornerRadius = 5
        return label
    }()
    
    private let totalAudiencesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let openDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let rankBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    private let fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        view.setContentHuggingPriority(.init(100), for: .vertical)
        return view
    }()
    
    private let currentRanklabel = MovieLabel(font: .largeTitle, isBold: true)
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentRanklabel.textColor = .white
        addSubViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal Methods
    func setup(with data: MovieCellData) {
        titleLabel.text = data.title
        currentRanklabel.text = data.currentRank
        setOpenDateLabel(with: data.openDate)
        setRankChangeLabel(with: data.rankChange)
        setTotalAudiencesCountLabel(with: data.totalAudience)
        setNewEntryBadgeLabel(with: data.isNewEntry)
        activityIndicator.startAnimating()
    }

    func setPosterImageView(with image: UIImage) {
        DispatchQueue.main.async {
            self.posterImageView.image = image
            self.activityIndicator.stopAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: Override Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        rankChangeBadgeLabel.isHidden = false
        setDefaultImage()
    }
}

// MARK: - Private Methods
private extension GridCell {
    
    func setOpenDateLabel(with openDate: String) {
        openDateLabel.text = openDate + " 개봉"
    }
    
    func setRankChangeLabel(with rankChange: String) {
        if Int(rankChange) ?? 0 > 0 {
            rankChangeBadgeLabel.text = "  " + rankChange + "▲" + "  "
            rankChangeBadgeLabel.layer.backgroundColor = UIColor.systemGreen.cgColor
        } else if Int(rankChange) ?? 0 < 0 {
            rankChangeBadgeLabel.text = "  " + rankChange + "▼" + "  "
            rankChangeBadgeLabel.layer.backgroundColor = UIColor.systemRed.cgColor
        } else {
            rankChangeBadgeLabel.isHidden = true
        }
    }
    
    func setNewEntryBadgeLabel(with isNewEntry: Bool) {
        if isNewEntry {
            newEntryBadgeLabel.text = " 신규진입 "
        } else {
            newEntryBadgeLabel.text = ""
        }
    }
    
    func setTotalAudiencesCountLabel(with totalAudience: String) {
        totalAudiencesCountLabel.text = "관객수 " + totalAudience.toDecimal() + "명"
    }
    
    func setDefaultImage() {
        let noSignImage = UIImage(systemName: "nosign")
        self.posterImageView.image = noSignImage
        self.posterImageView.contentMode = .scaleAspectFit
    }
}

// MARK: - Setup Layout
private extension GridCell {
    func addSubViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(posterImageView)
        posterImageView.addSubview(activityIndicator)
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(badgeStackView)
        badgeStackView.addArrangedSubview(rankChangeBadgeLabel)
        badgeStackView.addArrangedSubview(newEntryBadgeLabel)
        infoStackView.addArrangedSubview(totalAudiencesCountLabel)
        infoStackView.addArrangedSubview(openDateLabel)
        infoStackView.addArrangedSubview(fakeView)
        
        addSubview(rankBackgroundView)
        rankBackgroundView.addSubview(currentRanklabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            currentRanklabel.centerXAnchor.constraint(equalTo: rankBackgroundView.centerXAnchor),
            currentRanklabel.centerYAnchor.constraint(equalTo: rankBackgroundView.centerYAnchor),
            
            rankBackgroundView.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            rankBackgroundView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            rankBackgroundView.widthAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 0.2),
            rankBackgroundView.heightAnchor.constraint(equalTo: rankBackgroundView.widthAnchor),
            
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            posterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor)
        ])
    }
}
