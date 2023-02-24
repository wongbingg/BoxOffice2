//
//  AppDIContainer.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import Foundation

final class AppDIContainer {
    
    // MARK: - DIConatainers of Scenes
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        return HomeSceneDIContainer()
    }
}
