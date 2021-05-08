//
//  LabelFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: LabelFlowCoordinatorFactory
public protocol LabelFlowCoordinatorFactory  {
    func makeListController(request: LBListViewModelRequest,
                            response: LBListViewModelResponse,
                            route: LBListViewModelRoute) -> UIViewController
}

// MARK: LabelFlowCoordinator
public protocol LabelFlowCoordinator {
    func start(with instructor: LabelFlowCoordinatorInstructor)
}

// MARK: LabelFlowCoordinatorInstructor
public enum LabelFlowCoordinatorInstructor {
    case presentListUI(LBListViewModelRequest, LBListViewModelResponse, UIPresentProperties)
}

// MARK: DefaultLabelFlowCoordinator
public final class DefaultLabelFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: LabelFlowCoordinatorFactory
    let flowFactory: FlowCoordinatorFactory

    // MARK: Init Funciton
    public init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
        self.flowFactory = factory
    }
    
}

extension DefaultLabelFlowCoordinator: LabelFlowCoordinator {
    
    public func start(with instructor: LabelFlowCoordinatorInstructor) {
        switch instructor {
        case .presentListUI(let request, let response, let presentProperties):
            self.presentListUI(request: request, response: response, presentProperties: presentProperties)
        }
    }
    
}

extension DefaultLabelFlowCoordinator {
    
    private func initListUI(request: LBListViewModelRequest, response: LBListViewModelResponse) -> UIViewController {
        let route = LBListViewModelRoute()
        let controller = self.controllerFactory.makeListController(request: request,
                                                                   response: response,
                                                                   route: route)
        return controller
    }
    
    func presentListUI(request: LBListViewModelRequest,
                       response: LBListViewModelResponse,
                       presentProperties: UIPresentProperties) {
        guaranteeMainThread {
            let controller = self.initListUI(request: request, response: response)
            controller.isModalInPresentation = presentProperties.isModalInPresentation
            controller.modalPresentationStyle = presentProperties.modalPresentationStyle
            controller.modalTransitionStyle = presentProperties.modalTransitionStyle
            let navigationController = UINavigationController(rootViewController: controller)
            self.navigationController.present(navigationController, animated: true)
        }
    }
    
}
