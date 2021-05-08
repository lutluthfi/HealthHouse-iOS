//
//  ProfileFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.
//

import UIKit

// MARK: ProfileFlowCoordinatorFactory
public protocol ProfileFlowCoordinatorFactory  {
    func makePFPersonalizeController(request: PFPersonalizeViewModelRequest,
                                     route: PFPersonalizeViewModelRoute) -> UIViewController
    func makePFPreviewController(request: PFPreviewViewModelRequest,
                                 route: PFPreviewViewModelRoute) -> UIViewController
}

// MARK: ProfileFlowCoordinator
public protocol ProfileFlowCoordinator {
    func start(with instructor: ProfileFlowCoordinatorInstructor)
    func makePreviewUI(request: PFPreviewViewModelRequest) -> UIViewController
}

// MARK: ProfileFlowCoordinatorInstructor
public enum ProfileFlowCoordinatorInstructor {
    case pushToPersonalizeUI(PFPersonalizeViewModelRequest)
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
        case .pushToPersonalizeUI(let request):
            self.pushToPersonalizeUI(request: request)
        }
    }
    
    public func makePreviewUI(request: PFPreviewViewModelRequest) -> UIViewController {
        let route = PFPreviewViewModelRoute()
        let controller = self.controllerFactory.makePFPreviewController(request: request, route: route)
        return controller
    }
    
}

// MARK: PFPersonalizeUI
extension DefaultProfileFlowCoordinator {
    
    private func makePFPersonalizeUI(request: PFPersonalizeViewModelRequest) -> UIViewController {
        let route = PFPersonalizeViewModelRoute()
        let controller = self.controllerFactory.makePFPersonalizeController(request: request, route: route)
        return controller
    }
    
    func pushToPersonalizeUI(request: PFPersonalizeViewModelRequest) {
        guaranteeMainThread {
            let controller = self.makePFPersonalizeUI(request: request)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}
