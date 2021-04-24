//
//  ATCreateViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 23/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

// MARK: ATCreateViewModelResponse
enum ATCreateViewModelResponse {
}

// MARK: ATCreateViewModelDelegate
protocol ATCreateViewModelDelegate: class {
}

// MARK: ATCreateViewModelRequest
public struct ATCreateViewModelRequest {
}

// MARK: ATCreateViewModelRoute
public struct ATCreateViewModelRoute {
}

// MARK: ATCreateViewModelInput
protocol ATCreateViewModelInput {

    func viewDidLoad()

}

// MARK: ATCreateViewModelOutput
protocol ATCreateViewModelOutput {

}

// MARK: ATCreateViewModel
protocol ATCreateViewModel: ATCreateViewModelInput, ATCreateViewModelOutput { }

// MARK: DefaultATCreateViewModel
final class DefaultATCreateViewModel: ATCreateViewModel {

    // MARK: DI Variable
    weak var delegate: ATCreateViewModelDelegate?
    let request: ATCreateViewModelRequest
    let route: ATCreateViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(request: ATCreateViewModelRequest,
         route: ATCreateViewModelRoute) {
        self.request = request
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultATCreateViewModel {
    
    func viewDidLoad() {
    }
    
}
