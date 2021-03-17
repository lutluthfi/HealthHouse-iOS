//
//  LaunchFlowCoordinator.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: LaunchFlowCoordinatorFactory
public protocol LaunchFlowCoordinatorFactory  {
    func makeLNPostController(requestValue: LNPostViewModelRequestValue,
                              route: LNPostViewModelRoute) -> UIViewController
}

// MARK: LaunchFlowCoordinator
public protocol LaunchFlowCoordinator {
    func start(with instructor: LaunchFlowCoordinatorInstructor)
}

// MARK: LaunchFlowCoordinatorInstructor
public enum LaunchFlowCoordinatorInstructor {
    case post
}

// MARK: DefaultLaunchFlowCoordinator
public final class DefaultLaunchFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: LaunchFlowCoordinatorFactory
    let flowFactory: FlowCoordinatorFactory

    // MARK: Init Function
    public init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
        self.flowFactory = factory
    }
    
}

extension DefaultLaunchFlowCoordinator: LaunchFlowCoordinator {
    
    public func start(with instructor: LaunchFlowCoordinatorInstructor) {
    }
    
}
