//
//  HomeFlowCoordinator.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit

protocol HomeFlowCoordinatorDependencies: AnyObject {
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
    
    func makeMovieDetailViewController(actions: MovieDetailViewModelActions,
                                       movieCellData: MovieCellData) -> MovieDetailViewController
}

final class HomeFlowCoordinator {
    private let navigationController: UINavigationController
    private let dependencies: HomeFlowCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: HomeFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = HomeViewModelActions(showMovieDetail: showMovieDetail)
        let homeVC = dependencies.makeHomeViewController(actions: actions)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    // MARK: - View Transition
    private func showMovieDetail(with movieCellData: MovieCellData) {
        // 다음씬 생성 후 이동
        let actions = MovieDetailViewModelActions()
        let movieDetailVC = dependencies.makeMovieDetailViewController(
            actions: actions,
            movieCellData: movieCellData
        )
        navigationController.pushViewController(movieDetailVC, animated: true)
    }
}
