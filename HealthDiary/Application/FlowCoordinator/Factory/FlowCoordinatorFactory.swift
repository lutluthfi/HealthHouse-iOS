//
//  FlowCoordinatorFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation

public protocol FlowCoordinatorFactory {
    
    func makeHealthDiaryFlowCoordinator() -> HealthDiaryFlowCoordinator
    
    func makeLaunchFlowCoordinator() -> LaunchFlowCoordinator
    
    func makeProfileFlowCoordinator() -> ProfileFlowCoordinator
    
}
