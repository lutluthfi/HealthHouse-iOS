//
//  AppDIContainer+FlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/03/21.
//

import Foundation

extension AppDIContainer: FlowCoordinatorFactory {
    
    func makeActivityFlowCoordinator() -> ActivityFlowCoordinator {
        return DefaultActivityFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    func makeLocationFlowCoordinator() -> LocationFlowCoordinator {
        return DefaultLocationFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    func makeHealthDiaryFlowCoordinator() -> HealthDiaryFlowCoordinator {
        return DefaultHealthDiaryFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    func makeFlagFlowCoordinator() -> FlagFlowCoordinator {
        return DefaultFlagFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    func makeLaunchFlowCoordinator() -> LaunchFlowCoordinator {
        return DefaultLaunchFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    func makeProfileFlowCoordinator() -> ProfileFlowCoordinator {
        return DefaultProfileFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
}
