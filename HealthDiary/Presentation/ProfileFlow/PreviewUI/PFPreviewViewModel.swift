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

// MARK: PFPreviewViewModelRequest
public struct PFPreviewViewModelRequest {
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
    let request: PFPreviewViewModelRequest
    let route: PFPreviewViewModelRoute

    // MARK: UseCase Variable



    // MARK: Common Variable

    

    // MARK: Output ViewModel
    

    // MARK: Init Function
    init(request: PFPreviewViewModelRequest,
         route: PFPreviewViewModelRoute) {
        self.request = request
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultPFPreviewViewModel {
    
    func viewDidLoad() {
    }
    
}
