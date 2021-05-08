//
//  ATCreateViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 23/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import MapKit
import RxRelay
import RxSwift

// MARK: ATCreateViewModelResult
enum ATCreateViewModelResult {
}

// MARK: ATCreateViewModelRequest
public struct ATCreateViewModelRequest {
}

// MARK: ATCreateViewModelResponse
public class ATCreateViewModelResponse {
    
}

// MARK: ATCreateViewModelRoute
public struct ATCreateViewModelRoute {
    var presentCMSearchMapUI: ((LCSearchViewModelRequest, LCSearchViewModelResponse) -> Void)?
}

// MARK: ATCreateViewModelInput
protocol ATCreateViewModelInput {
    func viewDidLoad()
    func presentSearchUI()
}

// MARK: ATCreateViewModelOutput
protocol ATCreateViewModelOutput {
    var selectedLocation: PublishRelay<MKMapItem> { get }
}

// MARK: ATCreateViewModel
protocol ATCreateViewModel: ATCreateViewModelInput, ATCreateViewModelOutput { }

// MARK: DefaultATCreateViewModel
final class DefaultATCreateViewModel: ATCreateViewModel {

    // MARK: DI Variable
    let disposeBag = DisposeBag()
    let request: ATCreateViewModelRequest
    let route: ATCreateViewModelRoute

    // MARK: UseCase Variable
    

    // MARK: Common Variable
    

    // MARK: Output ViewModel
    let selectedLocation = PublishRelay<MKMapItem>()

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
    
    func presentSearchUI() {
        let response = LCSearchViewModelResponse()
        response
            .selectedMapItem
            .bind(to: self.selectedLocation)
            .disposed(by: self.disposeBag)
        let request = LCSearchViewModelRequest()
        self.route.presentCMSearchMapUI?(request, response)
    }
    
}
