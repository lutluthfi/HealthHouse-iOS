//
//  LCSearchViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import MapKit
import RxSwift

// MARK: LCSearchViewModelResult
enum LCSearchViewModelResult {
}

// MARK: LCSearchViewModelResponse
public struct LCSearchViewModelResponse {
    let selectedMapItem = PublishSubject<MKMapItem>()
}

// MARK: CMSearchMapViewModelRequest
public struct LCSearchViewModelRequest {
}

// MARK: LCSearchViewModelRoute
public struct LCSearchViewModelRoute {
}

// MARK: LCSearchViewModelInput
protocol LCSearchViewModelInput {
    func viewDidLoad()
    func doSelect(mapItem: MKMapItem)
}

// MARK: LCSearchViewModelOutput
protocol LCSearchViewModelOutput {
    
}

// MARK: LCSearchViewModel
protocol LCSearchViewModel: AnyObject, LCSearchViewModelInput, LCSearchViewModelOutput { }

// MARK: DefaultLCSearchViewModel
final class DefaultLCSearchViewModel: LCSearchViewModel {
    
    // MARK: DI Variable
    let request: LCSearchViewModelRequest
    let response: LCSearchViewModelResponse
    let route: LCSearchViewModelRoute
    
    // MARK: UseCase Variable
    
    
    
    // MARK: Common Variable
    
    
    
    // MARK: Output ViewModel
    
    
    // MARK: Init Function
    init(request: LCSearchViewModelRequest,
         response: LCSearchViewModelResponse,
         route: LCSearchViewModelRoute) {
        self.request = request
        self.response = response
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLCSearchViewModel {
    
    func viewDidLoad() {
    }
    
    func doSelect(mapItem: MKMapItem) {
        self.response.selectedMapItem.onNext(mapItem)
    }
    
}
