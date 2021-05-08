//
//  LocationFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/04/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import UIKit

public typealias SearchResultController = UIViewController&UISearchControllerDelegate&UISearchBarDelegate

// MARK: LocationFlowCoordinatorFactory
public protocol LocationFlowCoordinatorFactory  {
    func makeLCSearchController(request: LCSearchViewModelRequest,
                                response: LCSearchViewModelResponse,
                                route: LCSearchViewModelRoute) -> UIViewController
}

// MARK: LocationFlowCoordinator
public protocol LocationFlowCoordinator {
    func start(with instructor: LocationFlowCoordinatorInstructor)
    func makeLCSearchUI(request: LCSearchViewModelRequest,
                        response: LCSearchViewModelResponse) -> UIViewController
}

// MARK: LocationFlowCoordinatorInstructor
public enum LocationFlowCoordinatorInstructor {
    case presentSearchUI( SearchResultController)
}

// MARK: DefaultLocationFlowCoordinator
public final class DefaultLocationFlowCoordinator {
    
    // MARK: DI Variable
    let navigationController: UINavigationController
    let controllerFactory: LocationFlowCoordinatorFactory
    
    // MARK: Init Funciton
    public init(navigationController: UINavigationController, factory: PresentationFactory) {
        self.navigationController = navigationController
        self.controllerFactory = factory
    }
    
}

extension DefaultLocationFlowCoordinator: LocationFlowCoordinator {
    
    public func start(with instructor: LocationFlowCoordinatorInstructor) {
        switch instructor {
        case .presentSearchUI(let resultController):
            self.presentSearchUI(resultController: resultController)
        }
    }
    
    public func makeLCSearchUI(request: LCSearchViewModelRequest,
                               response: LCSearchViewModelResponse) -> UIViewController {
        let route = LCSearchViewModelRoute()
        let controller = self.controllerFactory.makeLCSearchController(request: request,
                                                                       response: response,
                                                                       route: route)
        return controller
    }
    
}

extension DefaultLocationFlowCoordinator {
    
    private func initSearchController(resultController: SearchResultController) -> UIViewController {
        let searchController = UISearchController(searchResultsController: resultController)
        searchController.delegate = resultController
        searchController.searchBar.delegate = resultController
        return searchController
    }
    
    func presentSearchUI(resultController: SearchResultController) {
        guaranteeMainThread { [unowned self] in
            let controller = self.initSearchController(resultController: resultController)
            self.navigationController.present(controller, animated: true)
        }
    }
    
}
