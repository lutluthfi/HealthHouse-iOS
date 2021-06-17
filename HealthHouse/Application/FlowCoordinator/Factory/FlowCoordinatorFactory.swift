//
//  FlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation

protocol FlowCoordinatorFactory {
    
    func makeActivityFlowCoordinator() -> ActivityFlowCoordinator
    
    func makeFlagFlowCoordinator() -> FlagFlowCoordinator
    
    func makeHealthDiaryFlowCoordinator() -> HealthDiaryFlowCoordinator
    
    func makeLaunchFlowCoordinator() -> LaunchFlowCoordinator
    
    func makeLocationFlowCoordinator() -> LocationFlowCoordinator
    
    func makeProfileFlowCoordinator() -> ProfileFlowCoordinator
    
}
