//
//  AppDIContainer+HealthDiaryFlowCoordinatorFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import UIKit

extension AppDIContainer: HealthDiaryFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makeHDTimelineController(requestValue: HDTimelineViewModelRequestValue,
                                         route: HDTimelineViewModelRoute) -> UIViewController {
        let viewModel = self.makeHDTimelineViewModel(requestValue: requestValue, route: route)
        return HDTimelineController.create(with: viewModel)
    }
    
    private func makeHDTimelineViewModel(requestValue: HDTimelineViewModelRequestValue,
                                         route: HDTimelineViewModelRoute) -> HDTimelineViewModel {
        return DefaultHDTimelineViewModel(requestValue: requestValue, route: route)
    }
    
}
