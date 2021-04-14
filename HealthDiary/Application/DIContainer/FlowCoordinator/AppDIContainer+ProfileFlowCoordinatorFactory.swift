//
//  AppDIContainer+ProfileFlowCoordinatorFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import UIKit

extension AppDIContainer: ProfileFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makePFPersonalizeController(requestValue: PFPersonalizeViewModelRequestValue,
                                            route: PFPersonalizeViewModelRoute) -> UIViewController {
        let viewModel = self.makePFPersonalizeViewModel(requestValue: requestValue, route: route)
        return PFPersonalizeController.create(with: viewModel)
    }
    
    private func makePFPersonalizeViewModel(requestValue: PFPersonalizeViewModelRequestValue,
                                            route: PFPersonalizeViewModelRoute) -> PFPersonalizeViewModel {
        return DefaultPFPersonalizeViewModel(requestValue: requestValue,
                                             route: route,
                                             fetchCountryDialingCodeUseCase: self.makeFetchCountryDialingCodeUseCase())
    }
    
}

extension AppDIContainer {
    
    public func makePFPreviewController(requestValue: PFPreviewViewModelRequestValue,
                                        route: PFPreviewViewModelRoute) -> UIViewController {
        let viewModel = self.makePFPreviewViewModel(requestValue: requestValue, route: route)
        return PFPreviewController.create(with: viewModel)
    }
    
    private func makePFPreviewViewModel(requestValue: PFPreviewViewModelRequestValue,
                                        route: PFPreviewViewModelRoute) -> PFPreviewViewModel {
        return DefaultPFPreviewViewModel(requestValue: requestValue, route: route)
    }
    
}
