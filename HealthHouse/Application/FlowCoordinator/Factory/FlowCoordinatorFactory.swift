//
//  FlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation

public protocol FlowCoordinatorFactory {
    
    func makeActivityFlowCoordinator() -> ActivityFlowCoordinator
    
    func makeLocationFlowCoordinator() -> LocationFlowCoordinator
    
    func makeHealthDiaryFlowCoordinator() -> HealthDiaryFlowCoordinator
    
    func makeLabelFlowCoordinator() -> LabelFlowCoordinator
    
    func makeLaunchFlowCoordinator() -> LaunchFlowCoordinator
    
    func makeProfileFlowCoordinator() -> ProfileFlowCoordinator
    
}
