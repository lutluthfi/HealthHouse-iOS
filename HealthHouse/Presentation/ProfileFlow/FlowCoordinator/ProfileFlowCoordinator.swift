//
//  ProfileFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.
//

import UIKit

// MARK: ProfileFlowCoordinatorFactory
protocol ProfileFlowCoordinatorFactory  {
    func makePFPersonalizeController(request: PFPersonalizeViewModelRequest,
                                     route: PFPersonalizeViewModelRoute) -> UIViewController
    func makePFPreviewController(request: PFPreviewViewModelRequest,
                                 route: PFPreviewViewModelRoute) -> UIViewController
}

// MARK: ProfileFlowCoordinator
protocol ProfileFlowCoordinator {
    func start(with instructor: ProfileFlowCoordinatorInstructor)
    func makePreviewUI(request: PFPreviewViewModelRequest) -> UIViewController
}

// MARK: ProfileFlowCoordinatorInstructor
enum ProfileFlowCoordinatorInstructor {
    case presentPersonalizeUI(PFPersonalizeViewModelRequest, UIPresentProperties)
    case pushToPersonalizeUI(PFPersonalizeViewModelRequest)
}

// MARK: DefaultProfileFlowCoordinator
final class DefaultProfileFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: ProfileFlowCoordinatorFactory
    let flowFactory: FlowCoordinatorFactory

    // MARK: Init Funciton
    init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
        self.flowFactory = factory
    }
    
}

extension DefaultProfileFlowCoordinator: ProfileFlowCoordinator {
    
    func start(with instructor: ProfileFlowCoordinatorInstructor) {
        switch instructor {
        case let .presentPersonalizeUI(request, presentProperties):
            self.presentPersonalizeUI(request: request, presentProperties: presentProperties)
        case let .pushToPersonalizeUI(request):
            self.pushToPersonalizeUI(request: request)
        }
    }
    
    func makePreviewUI(request: PFPreviewViewModelRequest) -> UIViewController {
        let route = PFPreviewViewModelRoute()
        let controller = self.controllerFactory.makePFPreviewController(request: request, route: route)
        return controller
    }
    
}

// MARK: PFPersonalizeUI
extension DefaultProfileFlowCoordinator {
    
    private func makePFPersonalizeUI(request: PFPersonalizeViewModelRequest) -> UIViewController {
        let pushToLNPadUI: (() -> Void) = {
            let instructor = LaunchFlowCoordinatorInstructor.pushToPadUI
            let coordinator = self.flowFactory.makeLaunchFlowCoordinator()
            coordinator.start(with: instructor)
        }
        let route = PFPersonalizeViewModelRoute(pushToLNPadUI: pushToLNPadUI)
        let controller = self.controllerFactory.makePFPersonalizeController(request: request, route: route)
        return controller
    }
    
    func presentPersonalizeUI(request: PFPersonalizeViewModelRequest, presentProperties: UIPresentProperties) {
        guaranteeMainThread {
            let controller = self.makePFPersonalizeUI(request: request)
            controller.isModalInPresentation = presentProperties.isModalInPresentation
            controller.modalPresentationStyle = presentProperties.modalPresentationStyle
            controller.modalTransitionStyle = presentProperties.modalTransitionStyle
            let navigationController = UINavigationController(rootViewController: controller)
            self.navigationController.presentWithSmart(controller: navigationController)
        }
    }
    
    func pushToPersonalizeUI(request: PFPersonalizeViewModelRequest) {
        guaranteeMainThread {
            let controller = self.makePFPersonalizeUI(request: request)
            self.navigationController.pushWithSmart(to: controller)
        }
    }
    
}
