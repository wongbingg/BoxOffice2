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
    private let homeCollectionView = HomeCollectionView()
    private let viewModel: HomeViewModel
    private var searchingDate: Date = Date().previousDate(to: -7)
    
    private let viewModeChangeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("▼ 일별 박스오피스", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.contentHorizontalAlignment = .left
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
    init(with viewModel: HomeViewModel) {
        self.viewModel = viewModel
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
        requestDailyBoxOffice()
        activityIndicator.startAnimating()
    }
    
    // MARK: Methods
    private func setupInitialView() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "영화목록"
        let calendarButton = UIBarButtonItem(
            image: UIImage(systemName: "calendar"),
            style: .done,
            target: self,
            action: #selector(calendarButtonTapped)
        )
        navigationItem.rightBarButtonItem = calendarButton
    }
    
    private func setupCollectionView() {
        homeCollectionView.currentDate = searchingDate.toString()
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
    
    private func requestDailyBoxOffice() {
        viewModel.requestDailyData(with: searchingDate.toString())
            .observe(on: MainScheduler.instance)
            .subscribe { [self] movieCellDatas in
                homeCollectionView.appendDailySnapshot(with: movieCellDatas)
                activityIndicator.stopAnimating()
            } onError: { error in
                print(error.localizedDescription)
                //alert
            }
            .disposed(by: disposeBag)
    }
    
    private func requestAllWeeksBoxOffice() {
        viewModel.requestAllWeekData(with: searchingDate.toString())
            .observe(on: MainScheduler.instance)
            .subscribe { [self] movieCellDatas in
                homeCollectionView.appendAllWeekSnapshot(with: movieCellDatas)
                activityIndicator.stopAnimating()
            } onError: { error in
                print(error.localizedDescription)
                //alert
            }
            .disposed(by: disposeBag)
    }
    
    private func requestWeekEndBoxOffice() {
        viewModel.requestWeekEndData(with: searchingDate.toString())
            .observe(on: MainScheduler.instance)
            .subscribe { [self] movieCellDatas in
                homeCollectionView.appendWeekEndSnapshot(with: movieCellDatas)
                activityIndicator.stopAnimating()
            } onError: { error in
                print(error.localizedDescription)
                //alert
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
}

// MARK: - UICollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        viewModeChangeButton.setTitle("▼ \(viewModel.viewMode.rawValue)", for: .normal)
        
        if mode == .daily {
            self.homeCollectionView.switchMode(.daily)
            requestDailyBoxOffice()
        } else {
            self.homeCollectionView.switchMode(.weekly)
            requestAllWeeksBoxOffice()
            requestWeekEndBoxOffice()
        }
    }
}

// MARK: - CalendarViewControllerDelegate
extension HomeViewController: CalendarViewControllerDelegate {
    
    func searchButtonTapped(date: Date) {
        activityIndicator.startAnimating()
        searchingDate = date
        let dateText = date.toString()
        homeCollectionView.currentDate = dateText
        
        if viewModeChangeButton.title(for: .normal) == "▼ 일별 박스오피스" {
            self.homeCollectionView.switchMode(.daily)
            requestDailyBoxOffice()
        } else {
            self.homeCollectionView.switchMode(.weekly)
            requestAllWeeksBoxOffice()
            requestWeekEndBoxOffice()
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
