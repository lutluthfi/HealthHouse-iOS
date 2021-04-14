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

    func makeLNPadController(requestValue: LNPadViewModelRequestValue,
                             route: LNPadViewModelRoute) -> UITabBarController
    
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
    case presentWelcomeUI(LNWelcomeViewModelRequestValue, UIPresentProperties)
    case pushToWelcomeUI(LNWelcomeViewModelRequestValue)
    case pushToPadUI(LNPadViewModelRequestValue)
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
    
    private func makePadUI(requestValue: LNPadViewModelRequestValue) -> UITabBarController {
        let route = LNPadViewModelRoute()
        let controller = self.controllerFactory.makeLNPadController(requestValue: requestValue, route: route)
        return controller
    }
    
    func pushToPadUI(requestValue: LNPadViewModelRequestValue) {
        guaranteeMainThread {
            let controller = self.makePadUI(requestValue: requestValue)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}

// MARK: Welcome UI
extension DefaultLaunchFlowCoordinator {
    
    private func makeWelcomeUI(requestValue: LNWelcomeViewModelRequestValue) -> UIViewController {
        let showLNPadUI: () -> Void = {
            let hdTimelineController = self.flowFactory
                .makeHealthDiaryFlowCoordinator()
                .makeTimelineUI(requestValue: HDTimelineViewModelRequestValue()) as! HDTimelineController
            let pfPreviewController = self.flowFactory
                .makeProfileFlowCoordinator()
                .makePreviewUI(requestValue: PFPreviewViewModelRequestValue()) as! PFPreviewController
            let controllers = LNPadViewModelRequestValue.Controllers(hdTimelineController: hdTimelineController,
                                                                     pfPreviewController: pfPreviewController)
            let lnPadRequestValue = LNPadViewModelRequestValue(controllers: controllers)
            self.start(with: .pushToPadUI(lnPadRequestValue))
        }
        let showPFPersonalizeUI: (PFPersonalizeViewModelRequestValue) -> Void = { requestValue in
            let instructor = ProfileFlowCoordinatorInstructor.pushToPersonalizeUI(requestValue)
            self.flowFactory.makeProfileFlowCoordinator().start(with: instructor)
        }
        let route = LNWelcomeViewModelRoute(showLNPadUI: showLNPadUI, showPFPersonalizeUI: showPFPersonalizeUI)
        let controller = self.controllerFactory.makeLNWelcomeController(requestValue: requestValue, route: route)
        return controller
    }
    
    func presentWelcomeUI(requestValue: LNWelcomeViewModelRequestValue, properties: UIPresentProperties) {
        guaranteeMainThread {
            let controller = self.makeWelcomeUI(requestValue: requestValue)
            controller.isModalInPresentation = properties.isModalInPresentation
            controller.modalPresentationStyle = properties.modalPresentationStyle
            controller.modalTransitionStyle = properties.modalTransitionStyle
            self.navigationController.present(controller, animated: true)
        }
    }
    
    func pushToWelcomeUI(requestValue: LNWelcomeViewModelRequestValue) {
        guaranteeMainThread {
            let controller = self.makeWelcomeUI(requestValue: requestValue)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
}
