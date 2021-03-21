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
    
    func makeLNWelcomeController(requestValue: LNWelcomeViewModelRequestValue,
                                 route: LNWelcomeViewModelRoute) -> UIViewController
}

// MARK: LaunchFlowCoordinator
public protocol LaunchFlowCoordinator {
    func start(with instructor: LaunchFlowCoordinatorInstructor)
}

// MARK: LaunchFlowCoordinatorInstructor
public enum LaunchFlowCoordinatorInstructor {
    case presentPostUI(LNPostViewModelRequestValue)
    case presentWelcomeUI(LNWelcomeViewModelRequestValue)
    case pushToPostUI(LNPostViewModelRequestValue)
    case pushToWelcomeUI(LNWelcomeViewModelRequestValue)
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
        switch instructor {
        case .presentPostUI(let requestValue):
            break
        case .presentWelcomeUI(let requestValue):
            self.presentWelcomeUI(requestValue: requestValue, properties: .standard)
        case .pushToPostUI(let requestValue):
            break
        case .pushToWelcomeUI(let requestValue):
            self.pushToWelcomeUI(requestValue: requestValue)
        }
    }
    
}

extension DefaultLaunchFlowCoordinator {
    
    func makeWelcomeUI(requestValue: LNWelcomeViewModelRequestValue) -> UIViewController {
        let route = LNWelcomeViewModelRoute()
        let controller = self.controllerFactory.makeLNWelcomeController(requestValue: requestValue, route: route)
        return controller
    }
    
    func presentWelcomeUI(requestValue: LNWelcomeViewModelRequestValue, properties: UIPresentProperties) {
        guaranteeMainThread {
            let controller = self.makeWelcomeUI(requestValue: requestValue)
            controller.isModalInPresentation = properties.isModalInPresentation
            controller.modalPresentationStyle = properties.modalPresentationStyle
            controller.modalTransitionStyle = properties.modalTransitionStyle
            self.navigationController.topViewController?.present(controller, animated: true)
        }
    }
    
    func pushToWelcomeUI(requestValue: LNWelcomeViewModelRequestValue) {
        guaranteeMainThread {
            let controller = self.makeWelcomeUI(requestValue: requestValue)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}
