//
//  HomeViewModel.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import Foundation
import RxSwift
import RxRelay

enum BoxOfficeMode: String, CaseIterable {
    case daily = "일별 박스오피스"
    case weekly = "주간/주말 박스오피스"
}

struct HomeViewModelActions {
    let showMovieDetail: (MovieCellData) -> Void
}

protocol HomeViewModelInput {
    func requestDailyData(with date: String)
    func requestAllWeekData(with date: String)
    func requestWeekEndData(with date: String)
    
    func movieTapped(at indexPath: IndexPath)
    func changeViewMode(to mode: BoxOfficeMode)
}

protocol HomeViewModelOutput{
    var viewMode: BoxOfficeMode { get }
    var dailyBoxOffices: BehaviorRelay<[MovieCellData]> { get }
    var allWeekBoxOffices: BehaviorRelay<[MovieCellData]> { get }
    var weekEndBoxOffices: BehaviorRelay<[MovieCellData]> { get }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

final class DefaultHomeViewModel: HomeViewModel {
    // MARK: Output
    private(set) var viewMode: BoxOfficeMode = .daily
    private(set) var dailyBoxOffices: BehaviorRelay<[MovieCellData]> = .init(value: [])
    private(set) var allWeekBoxOffices: BehaviorRelay<[MovieCellData]> = .init(value: [])
    private(set) var weekEndBoxOffices: BehaviorRelay<[MovieCellData]> = .init(value: [])
    
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
    
    // MARK: Input
    func requestDailyData(with date: String) {
        searchDailyBoxOfficeUseCase.execute(date: date)
            .subscribe { movieCellDatas in
                self.dailyBoxOffices.accept(movieCellDatas)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func requestAllWeekData(with date: String) {
        searchWeekDaysBoxOfficeUseCase.execute(date: date)
            .subscribe { movieCellDatas in
                self.allWeekBoxOffices.accept(movieCellDatas)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func requestWeekEndData(with date: String) {
        searchWeekEndBoxOfficeUseCase.execute(date: date)
            .subscribe { movieCellDatas in
                self.weekEndBoxOffices.accept(movieCellDatas)
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func movieTapped(at indexPath: IndexPath) {
        if viewMode == .daily {
            let movie = dailyBoxOffices.value[indexPath.row]
            self.actions?.showMovieDetail(movie)
        } else {
            
            if indexPath.section == 0 {
                let movie = allWeekBoxOffices.value[indexPath.row]
                self.actions?.showMovieDetail(movie)
            } else {
                let movie = weekEndBoxOffices.value[indexPath.row]
                self.actions?.showMovieDetail(movie)
            }
        }
    }
    
    func changeViewMode(to mode: BoxOfficeMode) {
        viewMode = mode
    }
}
