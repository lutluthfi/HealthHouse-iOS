//
//  HDTimelineViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxSwift

// MARK: HDTimelineViewModelResult
enum HDTimelineViewModelResult {
}

// MARK: HDTimelineViewModelRequest
public struct HDTimelineViewModelRequest {
}

// MARK: HDTimelineViewModelResponse
public struct HDTimelineViewModelResponse {
    
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
    let request: HDTimelineViewModelRequest
    let route: HDTimelineViewModelRoute

    // MARK: UseCase Variable
    let fetchAllActivityByProfileUseCase: FetchAllActivityByProfileUseCase

    // MARK: Common Variable
    

    // MARK: Output ViewModel
    let showedActivities = PublishSubject<[ActivityDomain]>()

    // MARK: Init Function
    init(request: HDTimelineViewModelRequest,
         route: HDTimelineViewModelRoute,
         fetchAllActivityByProfileUseCase: FetchAllActivityByProfileUseCase) {
        self.request = request
        self.route = route
        self.fetchAllActivityByProfileUseCase = fetchAllActivityByProfileUseCase
    }
    
}

// MARK: Input ViewModel
extension DefaultHDTimelineViewModel {
    
    func viewDidLoad() {
    }
    
}
