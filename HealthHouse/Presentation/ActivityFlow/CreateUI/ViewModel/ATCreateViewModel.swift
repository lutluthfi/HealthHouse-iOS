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
    var presentLBListUI: ((LBListViewModelRequest, LBListViewModelResponse) -> Void)?
    var presentLCSearchUI: ((LCSearchViewModelRequest, LCSearchViewModelResponse) -> Void)?
}

// MARK: ATCreateViewModelInput
protocol ATCreateViewModelInput {
    func viewDidLoad()
    func presentLBListUI()
    func presentLCSearchUI()
}

// MARK: ATCreateViewModelOutput
protocol ATCreateViewModelOutput {
    var selectedLocation: PublishRelay<MKMapItem> { get }
    var showedSelectedLabels: BehaviorRelay<[LabelDomain]> { get }
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
    let showedSelectedLabels = BehaviorRelay<[LabelDomain]>(value: [])

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
    
    func presentLBListUI() {
        let response = LBListViewModelResponse()
        response.selectedLabels
            .bind(to: self.showedSelectedLabels)
            .disposed(by: self.disposeBag)
        let request = LBListViewModelRequest(selectedLabels: [])
        self.route.presentLBListUI?(request, response)
    }
    
    func presentLCSearchUI() {
        let response = LCSearchViewModelResponse()
        response
            .selectedMapItem
            .bind(to: self.selectedLocation)
            .disposed(by: self.disposeBag)
        let request = LCSearchViewModelRequest()
        self.route.presentLCSearchUI?(request, response)
    }
    
}
