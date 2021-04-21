//
//  HDTimelineViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxSwift

// MARK: HDTimelineViewModelResponse
enum HDTimelineViewModelResponse {
}

// MARK: HDTimelineViewModelDelegate
protocol HDTimelineViewModelDelegate: class {
}

// MARK: HDTimelineViewModelRequest
public struct HDTimelineViewModelRequest {
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

    var showedActivities: PublishSubject<[ActivityDomain]> { get }
    
}

// MARK: HDTimelineViewModel
protocol HDTimelineViewModel: HDTimelineViewModelInput, HDTimelineViewModelOutput { }

// MARK: DefaultHDTimelineViewModel
final class DefaultHDTimelineViewModel: HDTimelineViewModel {

    // MARK: DI Variable
    weak var delegate: HDTimelineViewModelDelegate?
    let request: HDTimelineViewModelRequest
    let route: HDTimelineViewModelRoute

    // MARK: UseCase Variable
    

    // MARK: Common Variable
    

    // MARK: Output ViewModel
    let showedActivities = PublishSubject<[ActivityDomain]>()

    // MARK: Init Function
    init(request: HDTimelineViewModelRequest,
         route: HDTimelineViewModelRoute) {
        self.request = request
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultHDTimelineViewModel {
    
    func viewDidLoad() {
    }
    
}
