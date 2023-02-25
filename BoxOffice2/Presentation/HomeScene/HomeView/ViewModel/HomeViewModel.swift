//
//  HomeViewModel.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import Foundation
import RxSwift

struct HomeViewModelActions {
    let showMovieDetail: (MovieCellData) -> Void
}

protocol HomeViewModelInput {
    func requestDailyData(with date: String) -> Observable<[MovieCellData]>
    func requestAllWeekData(with date: String) -> Observable<[MovieCellData]>
    func requestWeekEndData(with date: String) -> Observable<[MovieCellData]>
    
    func movieTapped(at movie: MovieCellData)
}

protocol HomeViewModelOutput{

}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

final class DefaultHomeViewModel: HomeViewModel {
    private let disposeBag = DisposeBag()
    private let actions: HomeViewModelActions?
    private let searchDailyBoxOfficeUseCase: SearchDailyBoxOfficeUseCase
    private let searchWeekDaysBoxOfficeUseCase: SearchWeekDaysBoxOfficeUseCase
    private let searchWeekEndBoxOfficeUseCase: SearchWeekEndBoxOfficeUseCase
    
    init(
        actions: HomeViewModelActions?,
        searchDailyBoxOfficeUseCase: SearchDailyBoxOfficeUseCase,
        searchWeekDaysBoxOfficeUseCase: SearchWeekDaysBoxOfficeUseCase,
        searchWeekEndBoxOfficeUseCase: SearchWeekEndBoxOfficeUseCase
    ) {
        self.actions = actions
        self.searchDailyBoxOfficeUseCase = searchDailyBoxOfficeUseCase
        self.searchWeekDaysBoxOfficeUseCase = searchWeekDaysBoxOfficeUseCase
        self.searchWeekEndBoxOfficeUseCase = searchWeekEndBoxOfficeUseCase
    }
    
    func requestDailyData(with date: String) -> Observable<[MovieCellData]> {
        
        return Observable.create { [self] emitter in
            searchDailyBoxOfficeUseCase.execute(date: date)
                .subscribe { movieCellDatas in
                    emitter.onNext(movieCellDatas)
                    emitter.onCompleted()
                } onError: { error in
                    emitter.onError(error)
                }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    func requestAllWeekData(with date: String) -> Observable<[MovieCellData]> {
        
        return Observable.create { [self] emitter in
            searchWeekDaysBoxOfficeUseCase.execute(date: date)
                .subscribe { movieCellDatas in
                    emitter.onNext(movieCellDatas)
                    emitter.onCompleted()
                } onError: { error in
                    emitter.onError(error)
                }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    func requestWeekEndData(with date: String) -> Observable<[MovieCellData]> {
        
        return Observable.create { [self] emitter in
            searchWeekEndBoxOfficeUseCase.execute(date: date)
                .subscribe { movieCellDatas in
                    emitter.onNext(movieCellDatas)
                    emitter.onCompleted()
                } onError: { error in
                    emitter.onError(error)
                }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    func movieTapped(at movie: MovieCellData) {
        actions?.showMovieDetail(movie)
    }
}
