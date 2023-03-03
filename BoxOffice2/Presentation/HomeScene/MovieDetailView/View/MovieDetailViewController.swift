//
//  MovieDetailViewController.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/25.
//

import UIKit
import RxSwift

final class MovieDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let movieMainInfoView = MovieMainInfoView()
    private let movieSubInfoView = MovieSubInfoView()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets.init(
            top: 0,
            left: 0,
            bottom: 400,
            right: 0
        )
        return stackView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.tintColor = .systemBlue
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let viewModel: MovieDetailViewModel
    private let posterImageRepository: PosterImageRepository
    
    // MARK: Initializers
    init(
        with viewModel: MovieDetailViewModel,
        posterImageRepository: PosterImageRepository
    ) {
        self.viewModel = viewModel
        self.posterImageRepository = posterImageRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycles
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bindData()
        fetchInitialData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Methods
    private func bindData() {
        viewModel.movieDetailData
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] movieDetailData in
                self?.movieMainInfoView.configure(
                    with: movieDetailData,
                    rating: "",
                    repository: (self?.posterImageRepository)!
                )
                self?.movieSubInfoView.configure(with: movieDetailData)
                self?.activityIndicator.stopAnimating()
            } onError: { [weak self] error in
                guard let self = self else { return }
                DefaultAlertBuilder(message: error.localizedDescription)
                    .setButton()
                    .showAlert(on: self)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchInitialData() {
        viewModel.fetchMovieDetailData()
        activityIndicator.startAnimating()
    }
}

//MARK: Setup View
extension MovieDetailViewController {
    private func setupView() {
        movieSubInfoView.configure(with: viewModel.movieDetailData.value)
        
        addSubView()
        setupConstraint()
        addTagetButton()
        view.backgroundColor = .systemBackground
    }
}

//MARK: Button Action
extension MovieDetailViewController {
    private func addTagetButton() {
        movieSubInfoView.addTargetMoreButton(
            with: self,
            selector: #selector(moreActorButtonTapped)
        )
    }
    
    @objc private func moreActorButtonTapped() {
        let actorList = viewModel.movieDetailData.value.actors
        let actorListViewController = ActorListViewController(actorList: actorList)
        present(actorListViewController, animated: true)
    }
}

//MARK: Setup NavigationItem
extension MovieDetailViewController {
    private func setupNavigationItem() {
        let shareBarButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
        navigationItem.rightBarButtonItem = shareBarButton
        navigationItem.title = viewModel.movieDetailData.value.title
    }
    
    @objc private func shareButtonTapped() {
        let shareObject: [String] = viewModel.convertMovieInfo()
        let activityViewController = UIActivityViewController(
            activityItems: shareObject,
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true)
    }
}

// MARK: - Layout Constraints
private extension MovieDetailViewController {
    func addSubView() {
        entireStackView.addArrangedSubview(movieMainInfoView)
        entireStackView.addArrangedSubview(movieSubInfoView)
        view.addSubview(entireStackView)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            entireStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            entireStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            movieMainInfoView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                      multiplier: 1/3),
        ])
    }
}
