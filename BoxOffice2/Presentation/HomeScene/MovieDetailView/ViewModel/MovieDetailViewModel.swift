//
//  MovieDetailViewModel.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/25.
//

import RxSwift

struct MovieDetailViewModelActions {
    
}

protocol MovieDetailViewModelInput {
    func fetchMovieDetailData() -> Observable<MovieDetailData>
    func convertMovieInfo() -> [String]
}

protocol MovieDetailViewModelOutput {
    var movieDetailData: MovieDetailData { get }
}

protocol MovieDetailViewModel: MovieDetailViewModelInput, MovieDetailViewModelOutput {}

final class DefaultMovieDetailViewModel: MovieDetailViewModel {
    // MARK: Output
    private(set) var movieDetailData: MovieDetailData = MovieDetailData.stub()
    
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
    
    
    func fetchMovieDetailData() -> Observable<MovieDetailData> {
        
        return Observable.create { [self] emitter in
            searchMovieDetailUseCase.execute(movie: movieCellData)
                .subscribe { movieDetailData in
                    self.movieDetailData = movieDetailData
                    emitter.onNext(movieDetailData)
                } onError: { error in
                    emitter.onError(error)
                } onCompleted: {
                    emitter.onCompleted()
                }
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    func convertMovieInfo() -> [String] {
        let movieInfo = [
            movieDetailData.title,
            movieDetailData.openYear + " 개봉",
            movieDetailData.ageLimit,
            movieDetailData.currentRank + "위",
            movieDetailData.directorName,
            movieDetailData.actors.joined(separator: ","),
            movieDetailData.genreName,
            movieDetailData.isNewEntry ? "순위 진입" : "",
            movieDetailData.openDate,
            movieDetailData.rankChange + "단계 변동",
            movieDetailData.showTime + "분"
        ]
        
        return movieInfo
    }
}
