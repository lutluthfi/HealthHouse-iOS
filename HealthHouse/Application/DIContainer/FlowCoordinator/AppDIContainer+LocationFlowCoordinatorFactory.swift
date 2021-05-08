//
//  AppDIContainer+LocationFlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/04/21.
//

import UIKit

extension AppDIContainer: LocationFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makeLCSearchController(request: LCSearchViewModelRequest,
                                          response: LCSearchViewModelResponse,
                                          route: LCSearchViewModelRoute) -> UIViewController {
        let viewModel = self.makeCMSearchMapViewModel(request: request, response: response, route: route)
        return LCSearchController.create(with: viewModel)
    }
    
    private func makeCMSearchMapViewModel(request: LCSearchViewModelRequest,
                                          response: LCSearchViewModelResponse,
                                          route: LCSearchViewModelRoute) -> LCSearchViewModel {
        return DefaultLCSearchViewModel(request: request, response: response, route: route)
    }
    
}
