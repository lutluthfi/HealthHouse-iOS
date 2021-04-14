//
//  HDTimelineViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

// MARK: HDTimelineViewModelResponse
enum HDTimelineViewModelResponse {
}

// MARK: HDTimelineViewModelDelegate
protocol HDTimelineViewModelDelegate: class {
}

// MARK: HDTimelineViewModelRequestValue
public struct HDTimelineViewModelRequestValue {
}

// MARK: HDTimelineViewModelRoute
public struct HDTimelineViewModelRoute {
}

// MARK: HDTimelineViewModelInput
protocol HDTimelineViewModelInput {

    func viewDidLoad()

}

// MARK: HDTimelineViewModelOutput
protocol HDTimelineViewModelOutput {

}

// MARK: HDTimelineViewModel
protocol HDTimelineViewModel: HDTimelineViewModelInput, HDTimelineViewModelOutput { }

// MARK: DefaultHDTimelineViewModel
final class DefaultHDTimelineViewModel: HDTimelineViewModel {

    // MARK: DI Variable
    weak var delegate: HDTimelineViewModelDelegate?
    let requestValue: HDTimelineViewModelRequestValue
    let route: HDTimelineViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(requestValue: HDTimelineViewModelRequestValue,
         route: HDTimelineViewModelRoute) {
        self.requestValue = requestValue
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultHDTimelineViewModel {
    
    func viewDidLoad() {
    }
    
}
