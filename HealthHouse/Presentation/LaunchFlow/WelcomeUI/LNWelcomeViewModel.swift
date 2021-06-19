//
//  LNWelcomeViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/03/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxSwift

// MARK: LNWelcomeViewModelResult
enum LNWelcomeViewModelResult {
}

// MARK: LNWelcomeViewModelRequest
public struct LNWelcomeViewModelRequest {
}

// MARK: LNWelcomeViewModelResponse
public struct LNWelcomeViewModelResponse {
    
}

// MARK: LNWelcomeViewModelRoute
public struct LNWelcomeViewModelRoute {
    var showLNPadUI: (() -> Void)?
    var showPFPersonalizeUI: ((PFPersonalizeViewModelRequest, PFPersonalizeViewModelResponse) -> Void)?
}

// MARK: LNWelcomeViewModelInput
protocol LNWelcomeViewModelInput {
    func viewDidLoad()
    func doContinue()
}

// MARK: LNWelcomeViewModelOutput
protocol LNWelcomeViewModelOutput {
}

// MARK: LNWelcomeViewModel
protocol LNWelcomeViewModel: LNWelcomeViewModelInput, LNWelcomeViewModelOutput { }

// MARK: DefaultLNWelcomeViewModel
final class DefaultLNWelcomeViewModel: LNWelcomeViewModel {

    // MARK: DI Variable
    let request: LNWelcomeViewModelRequest
    let route: LNWelcomeViewModelRoute

    // MARK: UseCase Variable
    let updateAppConfigFirstLaunchUseCase: UpdateAppConfigFirstLaunchUseCase

    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(request: LNWelcomeViewModelRequest,
         route: LNWelcomeViewModelRoute,
         updateAppConfigFirstLaunchUseCase: UpdateAppConfigFirstLaunchUseCase) {
        self.request = request
        self.route = route
        self.updateAppConfigFirstLaunchUseCase = updateAppConfigFirstLaunchUseCase
    }
    
    func doUpdateAppConfigFirstLaunchUseCase(firstLaunch: Bool) -> Observable<UpdateAppConfigFirstLaunchUseCaseResponse> {
        let request = UpdateAppConfigFirstLaunchUseCaseRequest(firstLaunch: firstLaunch)
        return self.updateAppConfigFirstLaunchUseCase
            .execute(request)
            .asObservable()
    }
    
}

// MARK: Input ViewModel
extension DefaultLNWelcomeViewModel {
    
    func viewDidLoad() {
        self.doUpdateAppConfigFirstLaunchUseCase(firstLaunch: true)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func doContinue() {
        self.showPFPersonalizeUI()
    }
    
}

extension DefaultLNWelcomeViewModel {
    
    func showLNPadUI() {
        self.route.showLNPadUI?()
    }
    
    func showPFPersonalizeUI() {
        let request = PFPersonalizeViewModelRequest()
        let response = PFPersonalizeViewModelResponse()
        self.route.showPFPersonalizeUI?(request, response)
    }
    
}
