//
//  HomeSceneDIContainer.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit

final class HomeSceneDIContainer {
    
    private lazy var posterImageRepository = makePosterImageRepository()
    
    // MARK: - Home View
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        let viewModel = makeHomeViewModel(actions: actions)
        return HomeViewController(
            with: viewModel,
            posterImageRepository: posterImageRepository
        )
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        return DefaultHomeViewModel(
            actions: actions,
            searchDailyBoxOfficeUseCase: makeSearchDailyBoxOfficeUseCase(),
            searchWeekDaysBoxOfficeUseCase: makeSearchWeekDaysBoxOfficeUseCase(),
            searchWeekEndBoxOfficeUseCase: makeSearchWeekEndBoxOfficeUseCase()
        )
    }
    
    // MARK: - Movie Detail View
    func makeMovieDetailViewController(actions: MovieDetailViewModelActions,
                                       movieCellData: MovieCellData) -> MovieDetailViewController {
        let viewModel = makeMovieDetailViewModel(
            actions: actions,
            movieCellData: movieCellData
        )
        return MovieDetailViewController(
            with: viewModel,
            posterImageRepository: posterImageRepository
        )
    }
    
    func makeMovieDetailViewModel(actions: MovieDetailViewModelActions,
                                  movieCellData: MovieCellData) -> MovieDetailViewModel {
        
        return DefaultMovieDetailViewModel(
            actions: actions,
            movieCellData: movieCellData,
            searchMovieDetailUseCase: makeSearchMovieDetailUseCase()
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
    
    func makeSearchMovieDetailUseCase() -> SearchMovieDetailUseCase {
        return DefaultSearchMovieDetailUseCase(
            movieRepository: makeMovieRepository()
        )
    }
    
    // MARK: - Repositories
    func makeMovieRepository() -> MovieRepository {
        return DefaultMovieRepository()
    }
    
    func makePosterImageRepository() -> PosterImageRepository {
        return DefaultPosterImageRepository(
            imageCacheManager: DefaultImageCacheManager()
        )
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
