//
//  AppFlowCoordinator.swift
//  BoxOffice2
//
//  Created by 이원빈 on 2023/02/24.
//

import UIKit

final class AppFlowCoordinator {
    
    private var navigationController: UINavigationController!
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController!,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let homeSceneDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let flow = homeSceneDIContainer.makeHomeFlowCoordinator(
            navigationController: navigationController
        )
        flow.start()
    }
}
