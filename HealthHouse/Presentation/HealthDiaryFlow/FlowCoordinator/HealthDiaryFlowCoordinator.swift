//
//  HealthDiaryFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: HealthDiaryFlowCoordinatorFactory
protocol HealthDiaryFlowCoordinatorFactory  {
    func makeHDTimelineController(request: HDTimelineViewModelRequest,
                                  route: HDTimelineViewModelRoute) -> UIViewController
}

// MARK: HealthDiaryFlowCoordinator
protocol HealthDiaryFlowCoordinator {
    func start(with instructor: HealthDiaryFlowCoordinatorInstructor)
    func makeTimelineUI(request: HDTimelineViewModelRequest) -> UIViewController
}

// MARK: HealthDiaryFlowCoordinatorInstructor
enum HealthDiaryFlowCoordinatorInstructor {
}

// MARK: DefaultHealthDiaryFlowCoordinator
final class DefaultHealthDiaryFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: HealthDiaryFlowCoordinatorFactory
    let flowFactory: FlowCoordinatorFactory

    // MARK: Init Funciton
    init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
        self.flowFactory = factory
    }
    
}

extension DefaultHealthDiaryFlowCoordinator: HealthDiaryFlowCoordinator {
    
    func start(with instructor: HealthDiaryFlowCoordinatorInstructor) {
    }
    
    func makeTimelineUI(request: HDTimelineViewModelRequest) -> UIViewController {
        let route = HDTimelineViewModelRoute(presentPFPersonalizeUI: { (request) in
            let instructor = ProfileFlowCoordinatorInstructor.presentPersonalizeUI(request, .standard)
            self.flowFactory.makeProfileFlowCoordinator().start(with: instructor)
        }, pushToATCreateUI: { (request) in
            let instructor = ActivityFlowCoordinatorInstructor.pushToCreateUI(request)
            self.flowFactory.makeActivityFlowCoordinator().start(with: instructor)
        })
        let controller = self.controllerFactory.makeHDTimelineController(request: request, route: route)
        return controller
    }
    
}
