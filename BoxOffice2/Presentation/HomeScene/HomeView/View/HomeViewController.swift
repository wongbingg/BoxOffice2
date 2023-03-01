//
//  HomeViewController.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let homeCollectionView: HomeCollectionView
    private let viewModel: HomeViewModel
    private var searchingDate: Date = Date().previousDate(to: -7)
    private var currentOrientation: DeviceOrientation {
        if (UIDevice.current.orientation == .portrait) ||
            (UIDevice.current.orientation == .portraitUpsideDown) {
            return .portrait
        } else {
            return .landscape
        }
    }
    
    private let viewModeChangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("▼ 일별 박스오피스".localized(), for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.backgroundColor = .systemGray5
        button.contentHorizontalAlignment = .left
        button.accessibilityLabel = "보기모드 변경하기"
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.tintColor = .systemBlue
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: Initializers
    init(
        with viewModel: HomeViewModel,
        posterImageRepository: PosterImageRepository
    ) {
        self.viewModel = viewModel
        self.homeCollectionView = HomeCollectionView(
            viewModel: viewModel,
            posterImageRepository: posterImageRepository
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        setupNavigationBar()
        setupCollectionView()
        setupButton()
        addDeviceOrientationNoti()
        
        bindDailyBoxOffice()
        bindAllWeeksBoxOffice()
        bindWeekEndBoxOffice()
        
        activityIndicator.startAnimating()
        viewModel.requestDailyData(with: searchingDate.toString())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeDeviceOrientationNoti()
    }
    
    // MARK: Methods
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "영화목록".localized()
        let calendarButton = UIBarButtonItem(
            image: UIImage(systemName: "calendar"),
            style: .done,
            target: self,
            action: #selector(calendarButtonTapped)
        )
        navigationItem.rightBarButtonItem = calendarButton
    }
    
    private func setupCollectionView() {
        homeCollectionView.currentDate = searchingDate.toSectionHeaderString()
        homeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        homeCollectionView.delegate = self
        homeCollectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "headerView"
        )
    }
    
    private func setupButton() {
        viewModeChangeButton.addTarget(
            self,
            action: #selector(viewModeChangeButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func addDeviceOrientationNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(detectOrientation),
            name: NSNotification.Name("UIDeviceOrientationDidChangeNotification"),
            object: nil
        )
    }
    
    private func removeDeviceOrientationNoti() {
        NotificationCenter.default.removeObserver(NSNotification.Name("UIDeviceOrientationDidChangeNotification"))
    }
    
    private func bindDailyBoxOffice() {
        viewModel.dailyBoxOffices
            .observe(on: MainScheduler.instance)
            .subscribe { [self] movieCellDatas in
                homeCollectionView.appendDailySnapshot(with: movieCellDatas.map { $0.uuid })
                self.activityIndicator.stopAnimating()
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAllWeeksBoxOffice() {
        viewModel.allWeekBoxOffices
            .observe(on: MainScheduler.instance)
            .subscribe { [self] movieCellDatas in
                homeCollectionView.appendAllWeekSnapshot(with: movieCellDatas.map { $0.uuid })
                self.activityIndicator.stopAnimating()
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
            }
            .disposed(by: disposeBag)
    }
    
    private func bindWeekEndBoxOffice() {
        viewModel.weekEndBoxOffices
            .observe(on: MainScheduler.instance)
            .subscribe { [self] movieCellDatas in
                homeCollectionView.appendWeekEndSnapshot(with: movieCellDatas.map { $0.uuid })
                self.activityIndicator.stopAnimating()
            } onError: { error in
                print(error.localizedDescription)
            } onCompleted: {
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: @objc Methods
    @objc private func viewModeChangeButtonTapped() {
        let modeSelectViewController = ModeSelectViewController(passMode: viewModel.viewMode)
        modeSelectViewController.delegate = self
        
        present(modeSelectViewController, animated: true)
    }
    
    @objc private func calendarButtonTapped() {
        let calendarViewController = CalendarViewController()
        calendarViewController.delegate = self
        calendarViewController.datePicker.date = searchingDate
        
        present(calendarViewController, animated: true)
    }
    
    @objc private func detectOrientation() {
        if (UIDevice.current.orientation == .landscapeLeft) ||
            (UIDevice.current.orientation == .landscapeRight) {
            homeCollectionView.switchLayout(
                to: viewModel.viewMode,
                orientation: .landscape
            )
        } else if (UIDevice.current.orientation == .portrait) {
            homeCollectionView.switchLayout(
                to: viewModel.viewMode,
                orientation: .portrait
            )
        }
    }
}

// MARK: - UICollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        viewModel.movieTapped(at: indexPath)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height / 10
        return CGSize(width: width, height: height)
    }
}

// MARK: - ModeSelectViewController Delegate
extension HomeViewController: ModeSelectViewControllerDelegate {
    
    func didSelectedRowAt(indexPath: Int) {
        activityIndicator.startAnimating()
        let mode = BoxOfficeMode.allCases[indexPath]
        viewModel.changeViewMode(to: mode)
        viewModeChangeButton.setTitle(
            "▼ \(viewModel.viewMode.rawValue)".localized(),
            for: .normal
        )
        
        if mode == .daily {
            self.homeCollectionView.switchMode(.daily, orientation: currentOrientation)
            viewModel.requestDailyData(with: searchingDate.toString())
        } else {
            self.homeCollectionView.switchMode(.weekly, orientation: currentOrientation)
            viewModel.requestAllWeekData(with: searchingDate.toString())
            viewModel.requestWeekEndData(with: searchingDate.toString())
        }
    }
}

// MARK: - CalendarViewController Delegate
extension HomeViewController: CalendarViewControllerDelegate {
    
    func searchButtonTapped(date: Date) {
        activityIndicator.startAnimating()
        searchingDate = date
        let dateText = date.toSectionHeaderString()
        homeCollectionView.currentDate = dateText
        
        if viewModeChangeButton.title(for: .normal) == "▼ 일별 박스오피스" {
            self.homeCollectionView.switchMode(.daily, orientation: currentOrientation)
            viewModel.requestDailyData(with: searchingDate.toString())
        } else {
            self.homeCollectionView.switchMode(.weekly, orientation: currentOrientation)
            viewModel.requestAllWeekData(with: searchingDate.toString())
            viewModel.requestWeekEndData(with: searchingDate.toString())
        }
    }
}

// MARK: - Setup Layout
private extension HomeViewController {
    
    func addSubviews() {
        view.addSubview(homeCollectionView)
        view.addSubview(viewModeChangeButton)
        view.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            viewModeChangeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewModeChangeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            viewModeChangeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            viewModeChangeButton.heightAnchor.constraint(equalToConstant: 30),
            
            homeCollectionView.topAnchor.constraint(equalTo: viewModeChangeButton.bottomAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            homeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
