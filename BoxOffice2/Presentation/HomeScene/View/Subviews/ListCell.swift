//
//  ListCell.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit
import RxSwift

final class ListCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    private let imageCacheManager = DefaultImageCacheManager()
    
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
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        stackView.alignment = .top
        stackView.spacing = 10
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private let badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        view.setContentHuggingPriority(.init(100), for: .vertical)
        return view
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with data: MovieCellData) {
        titleLabel.text = data.title
        rankLabel.text = data.currentRank

        setOpenDateLabel(with: data.openDate)
        setRankChangeLabel(with: data.rankChange)
        setTotalAudiencesCountLabel(with: data.totalAudience)
        setNewEntryBadgeLabel(with: data.isNewEntry)

        activityIndicator.startAnimating()
        setPosterImageView(with: data)
            .observe(on: MainScheduler.instance)
            .subscribe { image in
                self.posterImageView.image = image
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
                self.activityIndicator.stopAnimating()
                // 컬렉션뷰 index 업데이트
                // TODO: 셀 이미지가 받아와 지고, 해당 indexPath에 있는 셀만 업데이트
            }
            .disposed(by: disposeBag)
    }
    
    func setPosterImageView(with data: MovieCellData) -> Observable<UIImage> {
        
        return Observable.create { emitter in
            SearchMoviePosterAPI(movieTitle: data.title).execute()
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
                            emitter.onNext(image)
                        } onError: { error in
                            emitter.onError(error)
                        } onCompleted: {
                            emitter.onCompleted()
                        }
                        .disposed(by: disposeBag)
                    
                } onError: { error in
                    print(error.localizedDescription)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
         
    }
    
    private func setOpenDateLabel(with openDate: String) {
        let characterArray = Array(openDate).map { String($0) }
        let date = characterArray[0...3].joined()
        + "-" + characterArray[4...5].joined()
        + "-" + characterArray[6...7].joined()
        + " 개봉"
        
        openDateLabel.text = date
    }
    
    private func setRankChangeLabel(with rankChange: String) {
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
    
    private func setNewEntryBadgeLabel(with isNewEntry: Bool) {
        if isNewEntry {
            newEntryBadgeLabel.text = " 신규진입 "
        } else {
            newEntryBadgeLabel.text = ""
        }
    }
    
    private func setTotalAudiencesCountLabel(with totalAudience: String) {
        totalAudiencesCountLabel.text = "관객수 " + totalAudience + "명"
    }
    
    override func draw(_ rect: CGRect) {
        let separator = UIBezierPath()
        separator.move(to: CGPoint(x: 0, y: bounds.maxY))
        separator.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        separator.lineWidth = 2
        UIColor.lightGray.setStroke()
        separator.stroke()
        separator.close()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankChangeBadgeLabel.isHidden = false
        posterImageView.image = UIImage()
    }
}

// MARK: Setup Layout
private extension ListCell {
    func addSubViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(posterImageView)
        posterImageView.addSubview(activityIndicator)
        mainStackView.addArrangedSubview(rankLabel)
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(badgeStackView)
        badgeStackView.addArrangedSubview(rankChangeBadgeLabel)
        badgeStackView.addArrangedSubview(newEntryBadgeLabel)
        infoStackView.addArrangedSubview(fakeView)
        infoStackView.addArrangedSubview(totalAudiencesCountLabel)
        infoStackView.addArrangedSubview(openDateLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            posterImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.25),
            posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor)
        ])
    }
}
