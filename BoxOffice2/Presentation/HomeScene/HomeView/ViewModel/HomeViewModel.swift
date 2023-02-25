//
//  HomeViewModel.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import Foundation
import RxSwift

enum BoxOfficeMode: String, CaseIterable {
    case daily = "일별 박스오피스"
    case weekly = "주간/주말 박스오피스"
}

struct HomeViewModelActions {
    let showMovieDetail: (MovieCellData) -> Void
}

protocol HomeViewModelInput {
    func requestDailyData(with date: String) -> Observable<[MovieCellData]>
    func requestAllWeekData(with date: String) -> Observable<[MovieCellData]>
    func requestWeekEndData(with date: String) -> Observable<[MovieCellData]>
    
    func movieTapped(at indexPath: IndexPath)
    func changeViewMode(to mode: BoxOfficeMode)
}

protocol HomeViewModelOutput{
    var dailyBoxOffices: [MovieCellData] { get }
    var allWeekBoxOffices: [MovieCellData] { get }
    var weekEndBoxOffices: [MovieCellData] { get }
    var viewMode: BoxOfficeMode { get }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

final class DefaultHomeViewModel: HomeViewModel {
    // MARK: Output
    private(set) var viewMode: BoxOfficeMode = .daily
    private(set) var dailyBoxOffices: [MovieCellData] = []
    private(set) var allWeekBoxOffices: [MovieCellData] = []
    private(set) var weekEndBoxOffices: [MovieCellData] = []
    
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
                    self.dailyBoxOffices = movieCellDatas
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
                    self.allWeekBoxOffices = movieCellDatas
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
                    self.weekEndBoxOffices = movieCellDatas
                    emitter.onNext(movieCellDatas)
                    emitter.onCompleted()
                } onError: { error in
                    emitter.onError(error)
                }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    func movieTapped(at indexPath: IndexPath) {
        if viewMode == .daily {
            let movie = dailyBoxOffices[indexPath.row]
            actions?.showMovieDetail(movie)
        } else {
            if indexPath.section == 0 {
                let movie = allWeekBoxOffices[indexPath.row]
                actions?.showMovieDetail(movie)
            } else {
                let movie = weekEndBoxOffices[indexPath.row]
                actions?.showMovieDetail(movie)
            }
        }
    }
    
    func changeViewMode(to mode: BoxOfficeMode) {
        viewMode = mode
    }
}
