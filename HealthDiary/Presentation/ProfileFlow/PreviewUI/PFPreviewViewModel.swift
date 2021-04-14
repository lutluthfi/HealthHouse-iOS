//
//  PFPreviewViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

// MARK: PFPreviewViewModelResponse
enum PFPreviewViewModelResponse {
}

// MARK: PFPreviewViewModelDelegate
protocol PFPreviewViewModelDelegate: class {
}

// MARK: PFPreviewViewModelRequestValue
public struct PFPreviewViewModelRequestValue {
}

// MARK: PFPreviewViewModelRoute
public struct PFPreviewViewModelRoute {
}

// MARK: PFPreviewViewModelInput
protocol PFPreviewViewModelInput {

    func viewDidLoad()

}

// MARK: PFPreviewViewModelOutput
protocol PFPreviewViewModelOutput {

}

// MARK: PFPreviewViewModel
protocol PFPreviewViewModel: PFPreviewViewModelInput, PFPreviewViewModelOutput { }

// MARK: DefaultPFPreviewViewModel
final class DefaultPFPreviewViewModel: PFPreviewViewModel {

    // MARK: DI Variable
    weak var delegate: PFPreviewViewModelDelegate?
    let requestValue: PFPreviewViewModelRequestValue
    let route: PFPreviewViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(requestValue: PFPreviewViewModelRequestValue,
         route: PFPreviewViewModelRoute) {
        self.requestValue = requestValue
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultPFPreviewViewModel {
    
    func viewDidLoad() {
    }
    
}
