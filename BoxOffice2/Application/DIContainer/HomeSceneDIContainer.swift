//
//  HomeSceneDIContainer.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit

final class HomeSceneDIContainer {
    
    // MARK: - Home View
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        let viewModel = makeHomeViewModel(actions: actions)
        return HomeViewController(with: viewModel)
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return DefaultHomeViewModel(
            actions: actions,
            searchDailyBoxOfficeUseCase: makeSearchDailyBoxOfficeUseCase(),
            searchWeekDaysBoxOfficeUseCase: makeSearchWeekDaysBoxOfficeUseCase(),
            searchWeekEndBoxOfficeUseCase: makeSearchWeekEndBoxOfficeUseCase()
        )
    }
    
    // MARK: - UseCases
    func makeSearchDailyBoxOfficeUseCase() -> SearchDailyBoxOfficeUseCase {
        return DefaultSearchDailyBoxOfficeUseCase(
            movieRepository: makeMovieRepository()
        )
    }
    
    func makeSearchWeekDaysBoxOfficeUseCase() -> SearchWeekDaysBoxOfficeUseCase {
        return DefaultSearchWeekDaysBoxOfficeUseCase(
            movieRepository: makeMovieRepository()
        )
    }
    
    func makeSearchWeekEndBoxOfficeUseCase() -> SearchWeekEndBoxOfficeUseCase {
        return DefaultSearchWeekEndBoxOfficeUseCase(
            movieRepository: makeMovieRepository()
        )
    }
    
    // MARK: - Repositories
    func makeMovieRepository() -> MovieRepository {
        return DefaultMovieRepository()
    }
    
    // MARK: - Home Flow Coordinator
    
    func makeHomeFlowCoordinator(
        navigationController: UINavigationController) -> HomeFlowCoordinator {
            
        return HomeFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension HomeSceneDIContainer: HomeFlowCoordinatorDependencies {}
