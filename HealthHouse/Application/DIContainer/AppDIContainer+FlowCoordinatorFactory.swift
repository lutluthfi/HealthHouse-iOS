//
//  AppDIContainer+FlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/03/21.
//

import Foundation

extension AppDIContainer: FlowCoordinatorFactory {
    
    public func makeActivityFlowCoordinator() -> ActivityFlowCoordinator {
        return DefaultActivityFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    public func makeLocationFlowCoordinator() -> LocationFlowCoordinator {
        return DefaultLocationFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    public func makeHealthDiaryFlowCoordinator() -> HealthDiaryFlowCoordinator {
        return DefaultHealthDiaryFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    public func makeFlagFlowCoordinator() -> FlagFlowCoordinator {
        return DefaultFlagFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    public func makeLaunchFlowCoordinator() -> LaunchFlowCoordinator {
        return DefaultLaunchFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
    public func makeProfileFlowCoordinator() -> ProfileFlowCoordinator {
        return DefaultProfileFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
}
