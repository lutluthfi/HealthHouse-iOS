//
//  AppDIContainer+FlowCoordinatorFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 20/03/21.
//

import Foundation

extension AppDIContainer: FlowCoordinatorFactory {
    
    public func makeLaunchFlowCoordinator() -> LaunchFlowCoordinator {
        return DefaultLaunchFlowCoordinator(navigationController: self.navigationController, factory: self)
    }
    
}
