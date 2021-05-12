//
//  LBCreateViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation

// MARK: LBCreateViewModelResult
enum LBCreateViewModelResult {
}

// MARK: LBCreateViewModelResponse
public struct LBCreateViewModelResponse {
}

// MARK: LBCreateViewModelRequest
public struct LBCreateViewModelRequest {
}

// MARK: LBCreateViewModelRoute
public struct LBCreateViewModelRoute {
}

// MARK: LBCreateViewModelInput
protocol LBCreateViewModelInput {

    func viewDidLoad()

}

// MARK: LBCreateViewModelOutput
protocol LBCreateViewModelOutput {

}

// MARK: LBCreateViewModel
protocol LBCreateViewModel: LBCreateViewModelInput, LBCreateViewModelOutput { }

// MARK: DefaultLBCreateViewModel
final class DefaultLBCreateViewModel: LBCreateViewModel {

    // MARK: DI Variable
    let request: LBCreateViewModelRequest
    let response: LBCreateViewModelResponse
    let route: LBCreateViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(request: LBCreateViewModelRequest,
         response: LBCreateViewModelResponse,
         route: LBCreateViewModelRoute) {
        self.request = request
        self.response = response
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLBCreateViewModel {
    
    func viewDidLoad() {
    }
    
}
