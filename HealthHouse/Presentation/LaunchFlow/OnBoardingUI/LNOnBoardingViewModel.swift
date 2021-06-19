//
//  LNOnBoardingViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/06/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation

// MARK: LNOnBoardingViewModelResponse
enum LNOnBoardingViewModelResponse {
}

// MARK: LNOnBoardingViewModelDelegate
protocol LNOnBoardingViewModelDelegate: class {
}

// MARK: LNOnBoardingViewModelRequest
public struct LNOnBoardingViewModelRequest {
}

// MARK: LNOnBoardingViewModelRoute
public struct LNOnBoardingViewModelRoute {
}

// MARK: LNOnBoardingViewModelInput
protocol LNOnBoardingViewModelInput {

    func viewDidLoad()

}

// MARK: LNOnBoardingViewModelOutput
protocol LNOnBoardingViewModelOutput {

}

// MARK: LNOnBoardingViewModel
protocol LNOnBoardingViewModel: LNOnBoardingViewModelInput, LNOnBoardingViewModelOutput { }

// MARK: DefaultLNOnBoardingViewModel
final class DefaultLNOnBoardingViewModel: LNOnBoardingViewModel {

    // MARK: DI Variable
    weak var delegate: LNOnBoardingViewModelDelegate?
    let request: LNOnBoardingViewModelRequest
    let route: LNOnBoardingViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(request: LNOnBoardingViewModelRequest,
         route: LNOnBoardingViewModelRoute) {
        self.request = request
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLNOnBoardingViewModel {
    
    func viewDidLoad() {
    }
    
}
