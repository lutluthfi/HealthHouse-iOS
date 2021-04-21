//
//  AppDIContainer+ProfileFlowCoordinatorFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import UIKit

extension AppDIContainer: ProfileFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makePFPersonalizeController(request: PFPersonalizeViewModelRequest,
                                            route: PFPersonalizeViewModelRoute) -> UIViewController {
        let viewModel = self.makePFPersonalizeViewModel(request: request, route: route)
        return PFPersonalizeController.create(with: viewModel)
    }
    
    private func makePFPersonalizeViewModel(request: PFPersonalizeViewModelRequest,
                                            route: PFPersonalizeViewModelRoute) -> PFPersonalizeViewModel {
        return DefaultPFPersonalizeViewModel(request: request,
                                             route: route,
                                             createProfileUseCase: self.makeCreateProfileUseCase(),
                                             fetchCountryDialingCodeUseCase: self.makeFetchCountryDialingCodeUseCase())
    }
    
}

extension AppDIContainer {
    
    public func makePFPreviewController(request: PFPreviewViewModelRequest,
                                        route: PFPreviewViewModelRoute) -> UIViewController {
        let viewModel = self.makePFPreviewViewModel(request: request, route: route)
        return PFPreviewController.create(with: viewModel)
    }
    
    private func makePFPreviewViewModel(request: PFPreviewViewModelRequest,
                                        route: PFPreviewViewModelRoute) -> PFPreviewViewModel {
        return DefaultPFPreviewViewModel(request: request, route: route)
    }
    
}
