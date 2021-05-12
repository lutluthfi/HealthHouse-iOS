//
//  AppDIContainer+LabelFlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//

import UIKit

extension AppDIContainer: LabelFlowCoordinatorFactory { }

// MARK: CreateUI
extension AppDIContainer {
    
    public func makeCreateController(request: LBCreateViewModelRequest,
                                     response: LBCreateViewModelResponse,
                                     route: LBCreateViewModelRoute) -> UIViewController {
        let viewModel = self.makeCreateViewModel(request: request, response: response, route: route)
        return LBCreateController.create(with: viewModel)
    }
    
    private func makeCreateViewModel(request: LBCreateViewModelRequest,
                                      response: LBCreateViewModelResponse,
                                      route: LBCreateViewModelRoute) -> LBCreateViewModel {
        return DefaultLBCreateViewModel(request: request, response: response, route: route)
    }
    
}

// MARK: ListUI
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
