//
//  AppDIContainer+LaunchFlowCoordinatorFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import UIKit

extension AppDIContainer: LaunchFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makeLNPadController(requestValue: LNPadViewModelRequestValue,
                                    route: LNPadViewModelRoute) -> UITabBarController {
        let viewModel = self.makeLNPadViewModel(requestValue: requestValue, route: route)
        return LNPadController.create(with: viewModel)
    }
    
    private func makeLNPadViewModel(requestValue: LNPadViewModelRequestValue,
                                    route: LNPadViewModelRoute) -> LNPadViewModel {
        return DefaultLNPadViewModel(requestValue: requestValue, route: route)
    }
    
}

extension AppDIContainer {
    
    public func makeLNPostController(requestValue: LNPostViewModelRequestValue,
                                     route: LNPostViewModelRoute) -> UIViewController {
        let viewModel = self.makeLNPostViewModel(requestValue: requestValue, route: route)
        return LNPostController.create(with: viewModel)
    }
    
    private func makeLNPostViewModel(requestValue: LNPostViewModelRequestValue,
                                     route: LNPostViewModelRoute) -> LNPostViewModel {
        return DefaultLNPostViewModel(requestValue: requestValue, route: route)
    }
    
}

extension AppDIContainer {
    
    public func makeLNWelcomeController(requestValue: LNWelcomeViewModelRequestValue,
                                        route: LNWelcomeViewModelRoute) -> UIViewController {
        let viewModel = self.makeLNWelcomeViewModel(requestValue: requestValue, route: route)
        return LNWelcomeController.create(with: viewModel)
    }
    
    private func makeLNWelcomeViewModel(requestValue: LNWelcomeViewModelRequestValue,
                                        route: LNWelcomeViewModelRoute) -> LNWelcomeViewModel {
        return DefaultLNWelcomeViewModel(requestValue: requestValue, route: route)
    }
    
}
