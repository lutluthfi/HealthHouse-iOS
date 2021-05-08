//
//  AppDIContainer+LaunchFlowCoordinatorFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import UIKit

extension AppDIContainer: LaunchFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makeLNPadController(request: LNPadViewModelRequest,
                                    route: LNPadViewModelRoute) -> UITabBarController {
        let viewModel = self.makeLNPadViewModel(request: request, route: route)
        return LNPadController.create(with: viewModel)
    }
    
    private func makeLNPadViewModel(request: LNPadViewModelRequest,
                                    route: LNPadViewModelRoute) -> LNPadViewModel {
        return DefaultLNPadViewModel(request: request, route: route)
    }
    
}

extension AppDIContainer {
    
    public func makeLNPostController(request: LNPostViewModelRequest,
                                     route: LNPostViewModelRoute) -> UIViewController {
        let viewModel = self.makeLNPostViewModel(request: request, route: route)
        return LNPostController.create(with: viewModel)
    }
    
    private func makeLNPostViewModel(request: LNPostViewModelRequest,
                                     route: LNPostViewModelRoute) -> LNPostViewModel {
        return DefaultLNPostViewModel(request: request, route: route)
    }
    
}

extension AppDIContainer {
    
    public func makeLNWelcomeController(request: LNWelcomeViewModelRequest,
                                        route: LNWelcomeViewModelRoute) -> UIViewController {
        let viewModel = self.makeLNWelcomeViewModel(request: request, route: route)
        return LNWelcomeController.create(with: viewModel)
    }
    
    private func makeLNWelcomeViewModel(request: LNWelcomeViewModelRequest,
                                        route: LNWelcomeViewModelRoute) -> LNWelcomeViewModel {
        return DefaultLNWelcomeViewModel(request: request, route: route)
    }
    
}
