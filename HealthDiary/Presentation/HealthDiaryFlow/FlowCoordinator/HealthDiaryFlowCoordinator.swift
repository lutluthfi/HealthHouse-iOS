//
//  HealthDiaryFlowCoordinator.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

// MARK: HealthDiaryFlowCoordinatorFactory
public protocol HealthDiaryFlowCoordinatorFactory  {
    
    func makeHDTimelineController(requestValue: HDTimelineViewModelRequestValue,
                                  route: HDTimelineViewModelRoute) -> UIViewController
    
}

// MARK: HealthDiaryFlowCoordinator
public protocol HealthDiaryFlowCoordinator {
    func start(with instructor: HealthDiaryFlowCoordinatorInstructor)
    
    func makeTimelineUI(requestValue: HDTimelineViewModelRequestValue) -> UIViewController
}

// MARK: HealthDiaryFlowCoordinatorInstructor
public enum HealthDiaryFlowCoordinatorInstructor {
    
}

// MARK: DefaultHealthDiaryFlowCoordinator
public final class DefaultHealthDiaryFlowCoordinator {

    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: HealthDiaryFlowCoordinatorFactory
    let flowFactory: FlowCoordinatorFactory

    // MARK: Init Funciton
    public init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
        self.flowFactory = factory
    }
    
}

extension DefaultHealthDiaryFlowCoordinator: HealthDiaryFlowCoordinator {
    
    public func start(with instructor: HealthDiaryFlowCoordinatorInstructor) {
    }
    
    public func makeTimelineUI(requestValue: HDTimelineViewModelRequestValue) -> UIViewController {
        let route = HDTimelineViewModelRoute()
        let controller = self.controllerFactory.makeHDTimelineController(requestValue: requestValue, route: route)
        return controller
    }
    
}
