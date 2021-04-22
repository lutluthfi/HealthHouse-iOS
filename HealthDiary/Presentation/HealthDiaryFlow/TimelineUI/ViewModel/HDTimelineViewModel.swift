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
    let fetchAllActivityUseCase: FetchAllActivityUseCase

    // MARK: Common Variable
    

    // MARK: Output ViewModel
    let showedActivities = PublishSubject<[ActivityDomain]>()

    // MARK: Init Function
    init(request: HDTimelineViewModelRequest,
         route: HDTimelineViewModelRoute,
         fetchAllActivityUseCase: FetchAllActivityUseCase) {
        self.request = request
        self.route = route
        self.fetchAllActivityUseCase = fetchAllActivityUseCase
    }
    
}

// MARK: Input ViewModel
extension DefaultHDTimelineViewModel {
    
    func viewDidLoad() {
        let profile = ProfileDomain(coreID: nil,
                                    createdAt: Date().toInt64(),
                                    updatedAt: Date().toInt64(),
                                    dateOfBirth: Date().toInt64(),
                                    firstName: "Health",
                                    gender: .male,
                                    lastName: "Diary",
                                    mobileNumbder: "1234567890",
                                    photoBase64String: nil)
        let activities = [ActivityDomain(coreID: nil,
                                         createdAt: Date().toInt64(),
                                         updatedAt: Date().toInt64(),
                                         doDate: Date().toInt64(),
                                         explanation: "Lorem ipsum",
                                         isArchived: false,
                                         isPinned: false,
                                         photoFileNames: [],
                                         title: "Lorem ipsum",
                                         profile: profile),
                          ActivityDomain(coreID: nil,
                                         createdAt: Date().toInt64(),
                                         updatedAt: Date().toInt64(),
                                         doDate: Date().toInt64(),
                                         explanation: "Lorem ipsum",
                                         isArchived: false,
                                         isPinned: false,
                                         photoFileNames: [],
                                         title: "Lorem ipsum",
                                         profile: profile)]
        self.showedActivities.onNext(activities)
    }
    
}
