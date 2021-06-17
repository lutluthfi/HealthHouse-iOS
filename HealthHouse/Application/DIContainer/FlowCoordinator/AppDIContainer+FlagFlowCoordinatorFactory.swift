//
//  AppDIContainer+FlagFlowCoordinatorFactory.swift.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//

import UIKit

extension AppDIContainer: FlagFlowCoordinatorFactory { }

// MARK: CreateUI
extension AppDIContainer {
    
    func makeCreateController(request: FLCreateViewModelRequest,
                              response: FLCreateViewModelResponse,
                              route: FLCreateViewModelRoute) -> UIViewController {
        let viewModel = self.makeCreateViewModel(request: request, response: response, route: route)
        return FLCreateController.create(with: viewModel)
    }
    
    private func makeCreateViewModel(request: FLCreateViewModelRequest,
                                     response: FLCreateViewModelResponse,
                                     route: FLCreateViewModelRoute) -> FLCreateViewModel {
        return DefaultFLCreateViewModel(request: request,
                                        response: response,
                                        route: route,
                                        createFlagUseCase: self.makeCreateFlagUseCase())
    }
    
}

// MARK: ListUI
extension AppDIContainer {
    
    func makeListController(request: FLListViewModelRequest,
                            response: FLListViewModelResponse,
                            route: FLListViewModelRoute) -> UIViewController {
        let viewModel = self.makeListViewModel(request: request, response: response, route: route)
        return FLListController.create(with: viewModel)
    }
    
    private func makeListViewModel(request: FLListViewModelRequest,
                                   response: FLListViewModelResponse,
                                   route: FLListViewModelRoute) -> FLListViewModel {
        return DefaultFLListViewModel(request: request,
                                      response: response,
                                      route: route,
                                      fetchAllFlagUseCase: self.makeFetchAllFlagUseCase(),
                                      fetchProfileUseCase: self.makeFetchCurrentProfileUseCase())
    }
    
}
