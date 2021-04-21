//
//  AppDIContainer+HealthDiaryFlowCoordinatorFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import UIKit

extension AppDIContainer: HealthDiaryFlowCoordinatorFactory { }

extension AppDIContainer {
    
    public func makeHDTimelineController(request: HDTimelineViewModelRequest,
                                         route: HDTimelineViewModelRoute) -> UIViewController {
        let viewModel = self.makeHDTimelineViewModel(request: request, route: route)
        return HDTimelineController.create(with: viewModel)
    }
    
    private func makeHDTimelineViewModel(request: HDTimelineViewModelRequest,
                                         route: HDTimelineViewModelRoute) -> HDTimelineViewModel {
        return DefaultHDTimelineViewModel(request: request, route: route)
    }
    
}
