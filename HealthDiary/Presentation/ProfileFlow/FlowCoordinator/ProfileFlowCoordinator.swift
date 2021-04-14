//
//  ProfileFlowCoordinator.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.
//

import UIKit

// MARK: ProfileFlowCoordinatorFactory
public protocol ProfileFlowCoordinatorFactory  {
    
    func makePFPersonalizeController(requestValue: PFPersonalizeViewModelRequestValue,
                                     route: PFPersonalizeViewModelRoute) -> UIViewController
    
    func makePFPreviewController(requestValue: PFPreviewViewModelRequestValue,
                                 route: PFPreviewViewModelRoute) -> UIViewController
    
}

// MARK: ProfileFlowCoordinator
public protocol ProfileFlowCoordinator {
    
    func start(with instructor: ProfileFlowCoordinatorInstructor)
    
    func makePreviewUI(requestValue: PFPreviewViewModelRequestValue) -> UIViewController
    
}

// MARK: ProfileFlowCoordinatorInstructor
public enum ProfileFlowCoordinatorInstructor {
    case pushToPersonalizeUI(PFPersonalizeViewModelRequestValue)
}

// MARK: DefaultProfileFlowCoordinator
public final class DefaultProfileFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: ProfileFlowCoordinatorFactory
    let flowFactory: FlowCoordinatorFactory

    // MARK: Init Funciton
    public init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
        self.flowFactory = factory
    }
    
}

extension DefaultProfileFlowCoordinator: ProfileFlowCoordinator {
    
    public func start(with instructor: ProfileFlowCoordinatorInstructor) {
        switch instructor {
        case .pushToPersonalizeUI(let requestValue):
            self.pushToPersonalizeUI(requestValue: requestValue)
        }
    }
    
    public func makePreviewUI(requestValue: PFPreviewViewModelRequestValue) -> UIViewController {
        let route = PFPreviewViewModelRoute()
        let controller = self.controllerFactory.makePFPreviewController(requestValue: requestValue, route: route)
        return controller
    }
    
}

// MARK: PFPersonalizeUI
extension DefaultProfileFlowCoordinator {
    
    private func makePFPersonalizeUI(requestValue: PFPersonalizeViewModelRequestValue) -> UIViewController {
        let route = PFPersonalizeViewModelRoute()
        let controller = self.controllerFactory.makePFPersonalizeController(requestValue: requestValue, route: route)
        return controller
    }
    
    func pushToPersonalizeUI(requestValue: PFPersonalizeViewModelRequestValue) {
        guaranteeMainThread {
            let controller = self.makePFPersonalizeUI(requestValue: requestValue)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}
