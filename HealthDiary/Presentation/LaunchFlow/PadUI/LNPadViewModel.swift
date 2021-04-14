//
//  LNPadViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxSwift

// MARK: LNPadViewModelResponse
enum LNPadViewModelResponse {
}

// MARK: LNPadViewModelDelegate
protocol LNPadViewModelDelegate: class {
}

// MARK: LNPadViewModelRequestValue
public struct LNPadViewModelRequestValue {
    
    public struct Controllers {
        
        public let hdTimelineController: HDTimelineController
        public let pfPreviewController: PFPreviewController
        
    }
    
    public let controllers: Controllers
    
}

// MARK: LNPadViewModelRoute
public struct LNPadViewModelRoute {
}

// MARK: LNPadViewModelInput
protocol LNPadViewModelInput {

    func viewDidAppear()

}

// MARK: LNPadViewModelOutput
protocol LNPadViewModelOutput {

    var controllers: PublishSubject<LNPadViewModelRequestValue.Controllers> { get }
    
}

// MARK: LNPadViewModel
protocol LNPadViewModel: LNPadViewModelInput, LNPadViewModelOutput { }

// MARK: DefaultLNPadViewModel
final class DefaultLNPadViewModel: LNPadViewModel {

    // MARK: DI Variable
    weak var delegate: LNPadViewModelDelegate?
    let requestValue: LNPadViewModelRequestValue
    let route: LNPadViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    let controllers = PublishSubject<LNPadViewModelRequestValue.Controllers>()

    // MARK: Init Function
    init(requestValue: LNPadViewModelRequestValue,
         route: LNPadViewModelRoute) {
        self.requestValue = requestValue
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLNPadViewModel {
    
    func viewDidAppear() {
        let controllers = self.requestValue.controllers
        self.controllers.onNext(controllers)
    }
    
}
