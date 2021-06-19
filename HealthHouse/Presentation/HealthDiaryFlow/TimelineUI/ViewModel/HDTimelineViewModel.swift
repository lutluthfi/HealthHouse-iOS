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
    var presentPFPersonalizeUI: ((PFPersonalizeViewModelRequest, PFPersonalizeViewModelResponse) -> Void)?
    var pushToATCreateUI: ((ATCreateViewModelRequest) -> Void)?
}

// MARK: HDTimelineViewModelInput
protocol HDTimelineViewModelInput {
    func viewDidLoad()
    func addBarButtonDidTap()
}

// MARK: HDTimelineViewModelOutput
protocol HDTimelineViewModelOutput {
    var showedActivities: PublishSubject<[Activity]> { get }
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
    let fetchCurrentProfileUseCase: FetchCurrentProfileUseCase

    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Output ViewModel
    let showedActivities = PublishSubject<[Activity]>()

    // MARK: Init Function
    init(request: HDTimelineViewModelRequest,
         route: HDTimelineViewModelRoute,
         fetchAllActivityByProfileUseCase: FetchAllActivityByProfileUseCase,
         fetchCurrentProfileUseCase: FetchCurrentProfileUseCase) {
        self.request = request
        self.route = route
        self.fetchAllActivityByProfileUseCase = fetchAllActivityByProfileUseCase
        self.fetchCurrentProfileUseCase = fetchCurrentProfileUseCase
    }
    
    func doFetchAllActivityByProfileUseCase(ownedBy profile: Profile) -> Observable<FetchAllActivityByProfileUseCaseResponse> {
        let request = FetchAllActivityByProfileUseCaseRequest(profile: profile)
        return self.fetchAllActivityByProfileUseCase.execute(request).asObservable()
    }
    
    func doFetchCurrentProfileUseCase() -> Observable<FetchCurrentProfileUseCaseResponse> {
        let request = FetchCurrentProfileUseCaseRequest()
        return self.fetchCurrentProfileUseCase.execute(request).asObservable()
    }
    
    func presentPFPersonalizeUI() {
        let request = PFPersonalizeViewModelRequest()
        let response = PFPersonalizeViewModelResponse()
        self.route.presentPFPersonalizeUI?(request, response)
    }
    
    func pushToATCreateUI() {
        let request = ATCreateViewModelRequest()
        self.route.pushToATCreateUI?(request)
    }
    
}

// MARK: Input ViewModel
extension DefaultHDTimelineViewModel {
    
    func viewDidLoad() {
        self.doFetchCurrentProfileUseCase()
            .compactMap({ $0.profile })
            .flatMap(self.doFetchAllActivityByProfileUseCase(ownedBy:))
            .map({ $0.activities })
            .subscribe(self.showedActivities)
            .disposed(by: self.disposeBag)
    }
    
    func addBarButtonDidTap() {
        self.doFetchCurrentProfileUseCase()
            .map { $0.profile }
            .subscribe(onNext: { [unowned self] (profile) in
                if profile != nil {
                    self.pushToATCreateUI()
                } else {
                    self.presentPFPersonalizeUI()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}
