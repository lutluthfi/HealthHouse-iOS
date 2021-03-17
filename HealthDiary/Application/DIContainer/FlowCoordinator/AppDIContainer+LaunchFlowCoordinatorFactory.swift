//
//  AppDIContainer+LaunchFlowCoordinatorFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import UIKit

extension AppDIContainer: LaunchFlowCoordinatorFactory { }

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
