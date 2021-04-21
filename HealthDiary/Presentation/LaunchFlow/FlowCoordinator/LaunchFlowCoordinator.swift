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
    case pushToPadUI(LNPadViewModelRequest)
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
        case .presentWelcomeUI(let requestValue, let properties):
            self.presentWelcomeUI(requestValue: requestValue, properties: properties)
        case .pushToWelcomeUI(let requestValue):
            self.pushToWelcomeUI(requestValue: requestValue)
        case .pushToPadUI(let requestValue):
            self.pushToPadUI(requestValue: requestValue)
        }
    }
    
}

// MARK: Pad UI
extension DefaultLaunchFlowCoordinator {
    
    private func makePadUI(requestValue: LNPadViewModelRequest) -> UITabBarController {
        let route = LNPadViewModelRoute()
        let controller = self.controllerFactory.makeLNPadController(request: requestValue, route: route)
        return controller
    }
    
    func pushToPadUI(requestValue: LNPadViewModelRequest) {
        guaranteeMainThread {
            let controller = self.makePadUI(requestValue: requestValue)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}

// MARK: Welcome UI
extension DefaultLaunchFlowCoordinator {
    
    private func makeWelcomeUI(requestValue: LNWelcomeViewModelRequest) -> UIViewController {
        let showLNPadUI: () -> Void = {
            let hdTimelineController = self.flowFactory
                .makeHealthDiaryFlowCoordinator()
                .makeTimelineUI(requestValue: HDTimelineViewModelRequest()) as! HDTimelineController
            let pfPreviewController = self.flowFactory
                .makeProfileFlowCoordinator()
                .makePreviewUI(request: PFPreviewViewModelRequest()) as! PFPreviewController
            let controllers = LNPadViewModelRequest.Controllers(hdTimelineController: hdTimelineController,
                                                                pfPreviewController: pfPreviewController)
            let lnPadRequestValue = LNPadViewModelRequest(controllers: controllers)
            self.start(with: .pushToPadUI(lnPadRequestValue))
        }
        let showPFPersonalizeUI: (PFPersonalizeViewModelRequest) -> Void = { requestValue in
            let instructor = ProfileFlowCoordinatorInstructor.pushToPersonalizeUI(requestValue)
            self.flowFactory.makeProfileFlowCoordinator().start(with: instructor)
        }
        let route = LNWelcomeViewModelRoute(showLNPadUI: showLNPadUI, showPFPersonalizeUI: showPFPersonalizeUI)
        let controller = self.controllerFactory.makeLNWelcomeController(request: requestValue, route: route)
        return controller
    }
    
    func presentWelcomeUI(requestValue: LNWelcomeViewModelRequest, properties: UIPresentProperties) {
        guaranteeMainThread {
            let controller = self.makeWelcomeUI(requestValue: requestValue)
            controller.isModalInPresentation = properties.isModalInPresentation
            controller.modalPresentationStyle = properties.modalPresentationStyle
            controller.modalTransitionStyle = properties.modalTransitionStyle
            self.navigationController.present(controller, animated: true)
        }
    }
    
    func pushToWelcomeUI(requestValue: LNWelcomeViewModelRequest) {
        guaranteeMainThread {
            let controller = self.makeWelcomeUI(requestValue: requestValue)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}
