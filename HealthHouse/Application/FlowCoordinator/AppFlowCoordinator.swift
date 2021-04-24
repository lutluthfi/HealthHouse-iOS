//
//  AppFlowCoordinator.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: AppFlowCoordinator
protocol AppFlowCoordinator {
    func start(with instructor: AppFlowCoordinatorInstructor)
}

// MARK: AppFlowCoordinatorInstructor
enum AppFlowCoordinatorInstructor {
    case `default`
}

// MARK: DefaultAppFlowCoordinator
final class DefaultAppFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let flowFactory: FlowCoordinatorFactory

    // MARK: Init Funciton
    init(navigationController: UINavigationController, presentationFactory: PresentationFactory) {
        self.navigationController = navigationController
        self.flowFactory = presentationFactory
    }
    
}

extension DefaultAppFlowCoordinator: AppFlowCoordinator {
    
    func start(with instructor: AppFlowCoordinatorInstructor) {
        switch instructor {
        case .default:
            let request = ATCreateViewModelRequest()
            let instructor = ActivityFlowCoordinatorInstructor.pushToCreateUI(request)
            self.flowFactory.makeActivityFlowCoordinator().start(with: instructor)
//            let request = LNWelcomeViewModelRequest()
//            let instructor = LaunchFlowCoordinatorInstructor.pushToWelcomeUI(request)
//            self.flowFactory.makeLaunchFlowCoordinator().start(with: instructor)
        }
    }
    
}
