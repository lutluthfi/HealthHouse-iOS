//
//  LNPostViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

// MARK: LNPostViewModelResponse
enum LNPostViewModelResponse {
}

// MARK: LNPostViewModelDelegate
protocol LNPostViewModelDelegate: class {
}

// MARK: LNPostViewModelRequest
public struct LNPostViewModelRequest {
}

// MARK: LNPostViewModelRoute
public struct LNPostViewModelRoute {
}

// MARK: LNPostViewModelInput
protocol LNPostViewModelInput {

    func viewDidLoad()

}

// MARK: LNPostViewModelOutput
protocol LNPostViewModelOutput {

}

// MARK: LNPostViewModel
protocol LNPostViewModel: LNPostViewModelInput, LNPostViewModelOutput { }

// MARK: DefaultLNPostViewModel
final class DefaultLNPostViewModel: LNPostViewModel {

    // MARK: DI Variable
    weak var delegate: LNPostViewModelDelegate?
    let request: LNPostViewModelRequest
    let route: LNPostViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(request: LNPostViewModelRequest,
         route: LNPostViewModelRoute) {
        self.request = request
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLNPostViewModel {
    
    func viewDidLoad() {
    }
    
}
