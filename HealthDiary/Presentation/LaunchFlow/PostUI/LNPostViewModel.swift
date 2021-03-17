//
//  LNPostViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.
//
//  Template:
//  Modified by Arif Luthfiansyah
//  Created by Oleh Kudinov

import Foundation

// MARK: LNPostViewModelResponse
enum LNPostViewModelResponse {
}

// MARK: LNPostViewModelDelegate
protocol LNPostViewModelDelegate: class {
}

// MARK: LNPostViewModelRequestValue
public struct LNPostViewModelRequestValue {
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
    let requestValue: LNPostViewModelRequestValue
    let route: LNPostViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(
        requestValue: LNPostViewModelRequestValue,
        route: LNPostViewModelRoute
    ) {
        self.requestValue = requestValue
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLNPostViewModel {
    
    func viewDidLoad() {
    }
    
}
