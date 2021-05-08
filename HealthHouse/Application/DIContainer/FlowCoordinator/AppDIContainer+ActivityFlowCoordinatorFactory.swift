//
//  AppDIContainer+ActivityFlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 23/04/21.
//

import UIKit

extension AppDIContainer: ActivityFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makeCreateController(request: ATCreateViewModelRequest,
                                     route: ATCreateViewModelRoute) -> UIViewController {
        let viewModel = self.makeCreateViewModel(request: request, route: route)
        return ATCreateController.create(with: viewModel)
    }
    
    private func makeCreateViewModel(request: ATCreateViewModelRequest,
                                     route: ATCreateViewModelRoute) -> ATCreateViewModel {
        return DefaultATCreateViewModel(request: request, route: route)
    }
    
}
