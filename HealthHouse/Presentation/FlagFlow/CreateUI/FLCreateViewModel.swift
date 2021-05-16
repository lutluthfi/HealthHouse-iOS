//
//  FLCreateViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation

// MARK: FLCreateViewModelResult
enum FLCreateViewModelResult {
}

// MARK: FLCreateViewModelResponse
public struct FLCreateViewModelResponse {
}

// MARK: FLCreateViewModelRequest
public struct FLCreateViewModelRequest {
}

// MARK: FLCreateViewModelRoute
public struct FLCreateViewModelRoute {
}

// MARK: FLCreateViewModelInput
protocol FLCreateViewModelInput {
    func viewDidLoad()
}

// MARK: FLCreateViewModelOutput
protocol FLCreateViewModelOutput {

}

// MARK: FLCreateViewModel
protocol FLCreateViewModel: FLCreateViewModelInput, FLCreateViewModelOutput { }

// MARK: DefaultFLCreateViewModel
final class DefaultFLCreateViewModel: FLCreateViewModel {

    // MARK: DI Variable
    let request: FLCreateViewModelRequest
    let response: FLCreateViewModelResponse
    let route: FLCreateViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(request: FLCreateViewModelRequest,
         response: FLCreateViewModelResponse,
         route: FLCreateViewModelRoute) {
        self.request = request
        self.response = response
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultFLCreateViewModel {
    
    func viewDidLoad() {
    }
    
}
