//
//  FlagFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: FlagFlowCoordinatorFactory
protocol FlagFlowCoordinatorFactory  {
    func makeCreateController(request: FLCreateViewModelRequest,
                              response: FLCreateViewModelResponse,
                              route: FLCreateViewModelRoute) -> UIViewController
    func makeListController(request: FLListViewModelRequest,
                            response: FLListViewModelResponse,
                            route: FLListViewModelRoute) -> UIViewController
}

// MARK: FlagFlowCoordinator
protocol FlagFlowCoordinator {
    func start(with instructor: FlagFlowCoordinatorInstructor)
}

// MARK: FlagFlowCoordinatorInstructor
enum FlagFlowCoordinatorInstructor {
    case presentCreateUI(FLCreateViewModelRequest, FLCreateViewModelResponse, UIPresentProperties)
    case presentListUI(FLListViewModelRequest, FLListViewModelResponse, UIPresentProperties)
}

// MARK: DefaultFlagFlowCoordinator
final class DefaultFlagFlowCoordinator {
    
    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: FlagFlowCoordinatorFactory
    let flowFactory: FlowCoordinatorFactory
    
    // MARK: Init Funciton
    init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
        self.flowFactory = factory
    }
    
}

extension DefaultFlagFlowCoordinator: FlagFlowCoordinator {
    
    func start(with instructor: FlagFlowCoordinatorInstructor) {
        switch instructor {
        case .presentCreateUI(let request, let response, let presentProperties):
            self.presentCreateUI(request: request, response: response, presentProperties: presentProperties)
        case .presentListUI(let request, let response, let presentProperties):
            self.presentListUI(request: request, response: response, presentProperties: presentProperties)
        }
    }
    
}

// MARK: CreateUI
extension DefaultFlagFlowCoordinator {
    
    private func initCreateUI(request: FLCreateViewModelRequest,
                              response: FLCreateViewModelResponse) -> UIViewController {
        let route = FLCreateViewModelRoute()
        let controller = self.controllerFactory.makeCreateController(request: request,
                                                                     response: response,
                                                                     route: route)
        return controller
    }
    
    func presentCreateUI(request: FLCreateViewModelRequest,
                         response: FLCreateViewModelResponse,
                         presentProperties: UIPresentProperties) {
        guaranteeMainThread {
            let controller = self.initCreateUI(request: request, response: response)
            controller.isModalInPresentation = presentProperties.isModalInPresentation
            controller.modalPresentationStyle = presentProperties.modalPresentationStyle
            controller.modalTransitionStyle = presentProperties.modalTransitionStyle
            let navigationController = UINavigationController(rootViewController: controller)
            self.navigationController.presentWithSmart(controller: navigationController)
        }
    }
    
    func pushToCreateUI(request: FLCreateViewModelRequest,
                        response: FLCreateViewModelResponse) {
        guaranteeMainThread {
            let controller = self.initCreateUI(request: request, response: response)
            self.navigationController.pushWithSmart(to: controller)
        }
    }
    
}

// MARK: ListUI
extension DefaultFlagFlowCoordinator {
    
    private func initListUI(request: FLListViewModelRequest, response: FLListViewModelResponse) -> UIViewController {
        let presentLBCreateUI = { (request: FLCreateViewModelRequest, response: FLCreateViewModelResponse) in
            let instructor = FlagFlowCoordinatorInstructor.presentCreateUI(request, response, .standard)
            self.start(with: instructor)
        }
        let route = FLListViewModelRoute(presentLBCreateUI: presentLBCreateUI)
        let controller = self.controllerFactory.makeListController(request: request,
                                                                   response: response,
                                                                   route: route)
        return controller
    }
    
    func presentListUI(request: FLListViewModelRequest,
                       response: FLListViewModelResponse,
                       presentProperties: UIPresentProperties) {
        guaranteeMainThread {
            let controller = self.initListUI(request: request, response: response)
            controller.isModalInPresentation = presentProperties.isModalInPresentation
            controller.modalPresentationStyle = presentProperties.modalPresentationStyle
            controller.modalTransitionStyle = presentProperties.modalTransitionStyle
            let navigationController = UINavigationController(rootViewController: controller)
            self.navigationController.presentWithSmart(controller: navigationController)
        }
    }
    
}
