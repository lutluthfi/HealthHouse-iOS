//
//  LaunchFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: LaunchFlowCoordinatorFactory
public protocol LaunchFlowCoordinatorFactory  {
    func makeLNPadController(request: LNPadViewModelRequest,
                             route: LNPadViewModelRoute) -> UITabBarController
    func makeLNPostController(request: LNPostViewModelRequest,
                              route: LNPostViewModelRoute) -> UIViewController
    func makeLNWelcomeController(request: LNWelcomeViewModelRequest,
                                 route: LNWelcomeViewModelRoute) -> UIViewController
}

// MARK: LaunchFlowCoordinator
public protocol LaunchFlowCoordinator {
    func start(with instructor: LaunchFlowCoordinatorInstructor)
}

// MARK: LaunchFlowCoordinatorInstructor
public enum LaunchFlowCoordinatorInstructor {
    case presentWelcomeUI(LNWelcomeViewModelRequest, UIPresentProperties)
    case pushToWelcomeUI(LNWelcomeViewModelRequest)
    case pushToPadUI
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

// MARK: Start Function
extension DefaultLaunchFlowCoordinator: LaunchFlowCoordinator {
    
    public func start(with instructor: LaunchFlowCoordinatorInstructor) {
        switch instructor {
        case .presentWelcomeUI(let request, let properties):
            self.presentWelcomeUI(request: request, properties: properties)
        case .pushToWelcomeUI(let request):
            self.pushToWelcomeUI(request: request)
        case .pushToPadUI:
            self.pushToPadUI()
        }
    }
    
}

// MARK: Pad UI
extension DefaultLaunchFlowCoordinator {
    
    private func makePadUI() -> UITabBarController {
        let hdTimelineController = self.flowFactory
            .makeHealthDiaryFlowCoordinator()
            .makeTimelineUI(request: HDTimelineViewModelRequest()) as! HDTimelineController
        let pfPreviewController = self.flowFactory
            .makeProfileFlowCoordinator()
            .makePreviewUI(request: PFPreviewViewModelRequest()) as! PFPreviewController
        let controllers = LNPadViewModelRequest.Controllers(hdTimelineController: hdTimelineController,
                                                            pfPreviewController: pfPreviewController)
        let request = LNPadViewModelRequest(controllers: controllers)
        let route = LNPadViewModelRoute()
        let controller = self.controllerFactory.makeLNPadController(request: request, route: route)
        return controller
    }
    
    func pushToPadUI() {
        guaranteeMainThread {
            let controller = self.makePadUI()
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}

// MARK: Welcome UI
extension DefaultLaunchFlowCoordinator {
    
    private func makeWelcomeUI(request: LNWelcomeViewModelRequest) -> UIViewController {
        let showLNPadUI: () -> Void = {
            let instructor = LaunchFlowCoordinatorInstructor.pushToPadUI
            self.start(with: instructor)
        }
        let showPFPersonalizeUI: (PFPersonalizeViewModelRequest) -> Void = { (request) in
            let instructor = ProfileFlowCoordinatorInstructor.pushToPersonalizeUI(request)
            self.flowFactory.makeProfileFlowCoordinator().start(with: instructor)
        }
        let route = LNWelcomeViewModelRoute(showLNPadUI: showLNPadUI, showPFPersonalizeUI: showPFPersonalizeUI)
        let controller = self.controllerFactory.makeLNWelcomeController(request: request, route: route)
        return controller
    }
    
    func presentWelcomeUI(request: LNWelcomeViewModelRequest, properties: UIPresentProperties) {
        guaranteeMainThread {
            let controller = self.makeWelcomeUI(request: request)
            controller.isModalInPresentation = properties.isModalInPresentation
            controller.modalPresentationStyle = properties.modalPresentationStyle
            controller.modalTransitionStyle = properties.modalTransitionStyle
            self.navigationController.present(controller, animated: true)
        }
    }
    
    func pushToWelcomeUI(request: LNWelcomeViewModelRequest) {
        guaranteeMainThread {
            let controller = self.makeWelcomeUI(request: request)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}
