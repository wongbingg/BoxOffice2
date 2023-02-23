//
//  SearchWeekDaysBoxOfficeUseCase.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/23.
//

import RxSwift

protocol SearchWeekDaysBoxOfficeUseCase {
    func execute(date: String) -> Observable<[MovieCellData]>
}

struct DefaultSearchWeekDaysBoxOfficeUseCase: SearchWeekDaysBoxOfficeUseCase {
    let movieRepository: MovieRepository
    
    func execute(date: String) -> Observable<[MovieCellData]> {
        
        return Observable.create { emitter in
            movieRepository.fetchWeekDaysMovies(date: date)
                .subscribe { movies in
                    emitter.onNext(movies)
                } onError: { error in
                    emitter.onError(error)
                }
        }
    }
}
