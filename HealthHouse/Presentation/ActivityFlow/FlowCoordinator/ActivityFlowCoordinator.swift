//
//  ActivityFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 23/04/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: ActivityFlowCoordinatorFactory
public protocol ActivityFlowCoordinatorFactory  {
    func makeCreateController(request: ATCreateViewModelRequest, route: ATCreateViewModelRoute) -> UIViewController
}

// MARK: ActivityFlowCoordinator
public protocol ActivityFlowCoordinator {
    func start(with instructor: ActivityFlowCoordinatorInstructor)
}

// MARK: ActivityFlowCoordinatorInstructor
public enum ActivityFlowCoordinatorInstructor {
    case pushToCreateUI(ATCreateViewModelRequest)
}

// MARK: DefaultActivityFlowCoordinator
public final class DefaultActivityFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: ActivityFlowCoordinatorFactory
    let flowFactory: FlowCoordinatorFactory

    // MARK: Init Funciton
    public init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
        self.flowFactory = factory
    }
    
}

extension DefaultActivityFlowCoordinator: ActivityFlowCoordinator {
    
    public func start(with instructor: ActivityFlowCoordinatorInstructor) {
        switch instructor {
        case .pushToCreateUI(let request):
            self.pushToCreateUI(request: request)
        }
    }
    
}

extension DefaultActivityFlowCoordinator {
    
    private func initCreateUI(request: ATCreateViewModelRequest) -> UIViewController {
        let presentLBListUI: (FLListViewModelRequest, FLListViewModelResponse) -> Void = { (request, response) in
            let coordinator = self.flowFactory.makeFlagFlowCoordinator()
            let instructor = FlagFlowCoordinatorInstructor.presentListUI(request, response, .standard)
            coordinator.start(with: instructor)
        }
        let presentLCSearchUI: (LCSearchViewModelRequest, LCSearchViewModelResponse) -> Void = { (request, response) in
            let coordinator = self.flowFactory.makeLocationFlowCoordinator()
            let instructor = LocationFlowCoordinatorInstructor.presentSearchUI(request, response, .standard)
            coordinator.start(with: instructor)
        }
        let route = ATCreateViewModelRoute(presentLBListUI: presentLBListUI,
                                           presentLCSearchUI: presentLCSearchUI)
        let controller = self.controllerFactory.makeCreateController(request: request, route: route)
        return controller
    }
    
    func pushToCreateUI(request: ATCreateViewModelRequest) {
        guaranteeMainThread {
            let controller = self.initCreateUI(request: request)
            self.navigationController.pushWithSmart(to: controller)
        }
    }
    
}
