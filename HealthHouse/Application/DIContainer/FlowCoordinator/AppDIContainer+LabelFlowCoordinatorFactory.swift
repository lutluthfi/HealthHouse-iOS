//
//  AppDIContainer+LabelFlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//

import UIKit

extension AppDIContainer: LabelFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makeListController(request: LBListViewModelRequest,
                                   response: LBListViewModelResponse,
                                   route: LBListViewModelRoute) -> UIViewController {
        let viewModel = self.makeListViewModel(request: request, response: response, route: route)
        return LBListController.create(with: viewModel)
    }
    
    private func makeListViewModel(request: LBListViewModelRequest,
                                   response: LBListViewModelResponse,
                                   route: LBListViewModelRoute) -> LBListViewModel {
        return DefaultLBListViewModel(request: request, response: response, route: route)
    }
    
}
