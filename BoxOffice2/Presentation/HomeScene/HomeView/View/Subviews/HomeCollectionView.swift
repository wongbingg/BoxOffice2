//
//  HomeCollectionView.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit
import RxSwift

enum DeviceOrientation {
    case landscape
    case portrait
}

final class HomeCollectionView: UICollectionView {

    private enum Section: String, CaseIterable {
        case allWeek = "주간 박스오피스"
        case weekEnd = "주말 박스오피스"
        case main
    }
    
    private var currentViewMode: BoxOfficeMode = .daily
    private var homeDataSource: UICollectionViewDiffableDataSource<Section, String>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    private var assets: [String: UIImage] = [:]
    
    private let disposeBag = DisposeBag()
    private let viewModel: HomeViewModel
    private let posterImageRepository: PosterImageRepository
    
    var currentDate = ""
    
    // MARK: Initializers
    init(
        viewModel: HomeViewModel,
        posterImageRepository: PosterImageRepository
    ) {
        self.viewModel = viewModel
        self.posterImageRepository = posterImageRepository
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        configureHierachy()
        configureDataSource(with: createDailyCellRegistration())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal Methods
    func appendDailySnapshot(with cellDatas: [String]) {
        guard cellDatas.count > 0 else { return }
        snapshot.appendItems(cellDatas)
        homeDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func appendAllWeekSnapshot(with data: [String]) {
        guard data.count > 0 else { return }
        snapshot.appendItems(data, toSection: .allWeek)
        homeDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func appendWeekEndSnapshot(with data: [String]) {
        guard data.count > 0 else { return }
        snapshot.appendItems(data, toSection: .weekEnd)
        homeDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func switchMode(_ mode: BoxOfficeMode, orientation: DeviceOrientation) {
        if mode == .daily {
            switchLayout(to: .daily, orientation: orientation)
            configureDataSource(with: createDailyCellRegistration())
        } else {
            switchLayout(to: .weekly, orientation: orientation)
            configureDataSource(with: createWeeklyCellRegistration())
        }
    }
    
    func switchLayout(to mode: BoxOfficeMode, orientation: DeviceOrientation) {
        if orientation == .portrait {
            if mode == .daily {
                setCollectionViewLayout(createDailyLayout(), animated: false)
                currentViewMode = .daily
            } else {
                setCollectionViewLayout(createWeeklyLayout(), animated: false)
                currentViewMode = .weekly
            }
        } else {
            if mode == .daily {
                setCollectionViewLayout(createLandscapeDailyLayout(), animated: false)
                currentViewMode = .daily
            } else {
                setCollectionViewLayout(createLandscapeWeeklyLayout(), animated: false)
                currentViewMode = .weekly
            }
        }
    }
}

private extension HomeCollectionView {
    // MARK: - Hierachy Setting
    func configureHierachy() {
        frame = bounds
        collectionViewLayout = createDailyLayout()
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Layout Settings
    func createDailyLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.25)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: "headerView",
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createLandscapeDailyLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: "headerView",
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createWeeklyLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.45),
            heightDimension: .fractionalHeight(0.45)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: "headerView",
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func createLandscapeWeeklyLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.23),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: "headerView",
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
  
    // MARK: - DataSource Settings
    func configureDataSource<T: UICollectionViewCell>(
        with cellRegistration: UICollectionView.CellRegistration<T, String>
    ) {
        let headerRegistration = createHeaderRegistration()
        homeDataSource = createDataSource(with: cellRegistration)
        
        homeDataSource?.supplementaryViewProvider = { [weak self] (view, kind, index) in
            return self?.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        if currentViewMode == .daily {
            snapshot.deleteAllItems()
            snapshot.appendSections([.main])
            homeDataSource?.apply(snapshot, animatingDifferences: false)
        } else {
            snapshot.deleteAllItems()
            snapshot.appendSections([.allWeek, .weekEnd])
            homeDataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func createDataSource<T: UICollectionViewCell>(
        with cellRegistration: UICollectionView.CellRegistration<T, String>
    ) -> UICollectionViewDiffableDataSource<Section, String>? {
        let dataSource = UICollectionViewDiffableDataSource<Section, String>(
            collectionView: self) {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             itemIdentifier: String) -> UICollectionViewCell? in
                
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        return dataSource
    }
    
    func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<HeaderView> {
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(
            elementKind: "headerView"
        ) { [weak self] (supplementaryView, elementKind, indexPath) in
            
            if self?.currentViewMode == .daily {
                guard self?.currentDate != "" else { return }
                supplementaryView.setHeaderViewTitle(text: self?.currentDate ?? "날짜정보없음")
            } else {
                let headerText = Section.allCases[indexPath.section].rawValue.localized()
                supplementaryView.setHeaderViewTitle(text: headerText)
            }
        }
        return headerRegistration
    }
    
    // MARK: - Cell Registration Settings
    func createDailyCellRegistration(
    ) -> UICollectionView.CellRegistration<ListCell, String> {
        
        let cellRegistration = UICollectionView.CellRegistration<ListCell, String> { [weak self] (cell, _, id) in
            guard let self = self else { return }
            let item = self.viewModel.dailyBoxOffices.value.filter { $0.uuid == id }
            self.setupCell(with: item[0], at: cell, id: id)
        }
        return cellRegistration
    }
    
    func createWeeklyCellRegistration(
    ) -> UICollectionView.CellRegistration<GridCell, String> {
        
        let cellRegistration = UICollectionView.CellRegistration<GridCell, String> { [weak self] cell, index, id in
            guard let self = self else { return }
            let list = self.viewModel.allWeekBoxOffices.value + self.viewModel.weekEndBoxOffices.value
            let item = list.filter { $0.uuid == id }
            self.setupCell(with: item[0], at: cell, id: id)
        }
        return cellRegistration
    }
    
    func setupCell(with item: MovieCellData, at cell: MovieCellProtocol, id: String) {
        cell.setup(with: item)

        if let image = self.assets[item.title] {
            cell.setPosterImageView(with: image)
        } else {
            self.posterImageRepository.fetchPosterImage(with: item.title, year: nil)
                .subscribe { [weak self] image in
                    guard let image = image else { return }
                    cell.setPosterImageView(with: image)
                    self?.assets[item.title] = image
                } onError: { error in
                    print(error.localizedDescription)
                    cell.stopActivityIndicator()
                } onCompleted: {
                    DispatchQueue.main.async { [weak self] in
                        self?.setPostNeedsUpdate(id: id)
                    }
                }
                .disposed(by: self.disposeBag)
        }
    }
    
    func setPostNeedsUpdate(id: String) {
        
        guard var snapshot = self.homeDataSource?.snapshot() else { return }
        snapshot.reconfigureItems([id])
        self.homeDataSource?.apply(snapshot, animatingDifferences: true)
    }
}
