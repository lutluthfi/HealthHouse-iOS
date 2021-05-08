//
//  LNPadViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

// MARK: LNPadViewModelResponse
enum LNPadViewModelResponse {
}

// MARK: LNPadViewModelDelegate
protocol LNPadViewModelDelegate: class {
}

// MARK: LNPadViewModelRequestValue
struct LNPadViewModelRequestValue {
}

// MARK: LNPadViewModelRoute
struct LNPadViewModelRoute {
}

// MARK: LNPadViewModelInput
protocol LNPadViewModelInput {

    func viewDidLoad()

}

// MARK: LNPadViewModelOutput
protocol LNPadViewModelOutput {

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
    

    // MARK: Init Function
    init(requestValue: LNPadViewModelRequestValue,
         route: LNPadViewModelRoute) {
        self.requestValue = requestValue
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLNPadViewModel {
    
    func viewDidLoad() {
    }
    
}
