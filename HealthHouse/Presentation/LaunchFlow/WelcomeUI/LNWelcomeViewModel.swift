//
//  LNWelcomeViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/03/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

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
    var showPFPersonalizeUI: ((PFPersonalizeViewModelRequest) -> Void)?
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



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(request: LNWelcomeViewModelRequest,
         route: LNWelcomeViewModelRoute) {
        self.request = request
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLNWelcomeViewModel {
    
    func viewDidLoad() {
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
        self.route.showPFPersonalizeUI?(request)
    }
    
}
