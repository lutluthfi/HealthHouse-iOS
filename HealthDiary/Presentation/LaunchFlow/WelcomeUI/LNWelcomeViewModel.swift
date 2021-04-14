//
//  LNWelcomeViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 20/03/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

// MARK: LNWelcomeViewModelResponse
enum LNWelcomeViewModelResponse {
}

// MARK: LNWelcomeViewModelDelegate
protocol LNWelcomeViewModelDelegate: class {
}

// MARK: LNWelcomeViewModelRequestValue
public struct LNWelcomeViewModelRequestValue {
}

// MARK: LNWelcomeViewModelRoute
public struct LNWelcomeViewModelRoute {
    
    var showLNPadUI: (() -> Void)?
    var showPFPersonalizeUI: ((PFPersonalizeViewModelRequestValue) -> Void)?
    
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
    weak var delegate: LNWelcomeViewModelDelegate?
    let requestValue: LNWelcomeViewModelRequestValue
    let route: LNWelcomeViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(requestValue: LNWelcomeViewModelRequestValue,
         route: LNWelcomeViewModelRoute) {
        self.requestValue = requestValue
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLNWelcomeViewModel {
    
    func viewDidLoad() {
    }
    
    func doContinue() {
        self.showPFPersonalizeUI()
//        self.showLNPadUI()
    }
    
}

extension DefaultLNWelcomeViewModel {
    
    func showLNPadUI() {
        self.route.showLNPadUI?()
    }
    
    func showPFPersonalizeUI() {
        let requestValue = PFPersonalizeViewModelRequestValue()
        self.route.showPFPersonalizeUI?(requestValue)
    }
    
}
