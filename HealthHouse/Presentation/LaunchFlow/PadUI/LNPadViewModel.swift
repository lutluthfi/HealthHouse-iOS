//
//  LNPadViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxSwift

// MARK: LNPadViewModelResult
enum LNPadViewModelResult {
}

// MARK: LNPadViewModelRequest
public struct LNPadViewModelRequest {
    
    public struct Controllers {
        public let hdTimelineController: HDTimelineController
        public let pfPreviewController: PFPreviewController
    }
    
    public let controllers: Controllers
    
}

// MARK: LNPadViewModelResponse
public struct LNPadViewModelResponse {
    
}

// MARK: LNPadViewModelRoute
public struct LNPadViewModelRoute {
    var presentPFPersonalizeUI: ((PFPersonalizeViewModelRequest, PFPersonalizeViewModelResponse) -> Void)?
}

// MARK: LNPadViewModelInput
protocol LNPadViewModelInput {
    func viewDidAppear()
    func profileTabBarDidSelect()
}

// MARK: LNPadViewModelOutput
protocol LNPadViewModelOutput {
    var controllers: PublishSubject<LNPadViewModelRequest.Controllers> { get }
    var pfPersonalizeUIDidDismiss: PublishSubject<Void> { get }
}

// MARK: LNPadViewModel
protocol LNPadViewModel: LNPadViewModelInput, LNPadViewModelOutput { }

// MARK: DefaultLNPadViewModel
final class DefaultLNPadViewModel: LNPadViewModel {

    // MARK: DI Variable
    let request: LNPadViewModelRequest
    let route: LNPadViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Output ViewModel
    let controllers = PublishSubject<LNPadViewModelRequest.Controllers>()
    let pfPersonalizeUIDidDismiss = PublishSubject<Void>()

    // MARK: Init Function
    init(request: LNPadViewModelRequest,
         route: LNPadViewModelRoute) {
        self.request = request
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLNPadViewModel {
    
    func viewDidAppear() {
        let controllers = self.request.controllers
        self.controllers.onNext(controllers)
    }
    
    func profileTabBarDidSelect() {
        let request = PFPersonalizeViewModelRequest()
        let response = PFPersonalizeViewModelResponse()
        response
            .controllerDidDismiss
            .bind(to: self.pfPersonalizeUIDidDismiss)
            .disposed(by: self.disposeBag)
        self.route.presentPFPersonalizeUI?(request, response)
    }
    
}
