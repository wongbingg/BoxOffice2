//
//  MovieDetailViewModel.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/25.
//

import RxSwift
import RxRelay

struct MovieDetailViewModelActions {
    
}

protocol MovieDetailViewModelInput {
    func fetchMovieDetailData()
    func convertMovieInfo() -> [String]
}

protocol MovieDetailViewModelOutput {
    var movieDetailData: BehaviorRelay<MovieDetailData> { get }
}

protocol MovieDetailViewModel: MovieDetailViewModelInput, MovieDetailViewModelOutput {}

final class DefaultMovieDetailViewModel: MovieDetailViewModel {
    // MARK: Output
    private(set) var movieDetailData: BehaviorRelay<MovieDetailData> = .init(
        value: MovieDetailData.stub()
    )
    
    private let disposeBag = DisposeBag()
    private let actions: MovieDetailViewModelActions
    private let movieCellData: MovieCellData
    private let searchMovieDetailUseCase: SearchMovieDetailUseCase
    
    init(
        actions: MovieDetailViewModelActions,
        movieCellData: MovieCellData,
        searchMovieDetailUseCase: SearchMovieDetailUseCase
    ) {
        self.actions = actions
        self.movieCellData = movieCellData
        self.searchMovieDetailUseCase = searchMovieDetailUseCase
    }
    
    func fetchMovieDetailData() {
        searchMovieDetailUseCase.execute(movie: movieCellData)
            .subscribe { [weak self] movieDetailData in
                self?.movieDetailData.accept(movieDetailData)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func convertMovieInfo() -> [String] {
        let movieInfo = [
            movieDetailData.value.title,
            movieDetailData.value.openYear + " 개봉",
            movieDetailData.value.ageLimit,
            movieDetailData.value.currentRank + "위",
            movieDetailData.value.directorName,
            movieDetailData.value.actors.joined(separator: ","),
            movieDetailData.value.genreName,
            movieDetailData.value.isNewEntry ? "순위 진입" : "",
            movieDetailData.value.openDate,
            movieDetailData.value.rankChange + "단계 변동",
            movieDetailData.value.showTime + "분"
        ]
        
        return movieInfo
    }
}
