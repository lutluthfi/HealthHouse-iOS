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
    var presentLBListUI: ((FLListViewModelRequest, FLListViewModelResponse) -> Void)?
    var presentLCSearchUI: ((LCSearchViewModelRequest, LCSearchViewModelResponse) -> Void)?
}

// MARK: ATCreateViewModelInput
protocol ATCreateViewModelInput {
    func viewDidLoad()
    func presentFLListUI()
    func presentLCSearchUI()
}

// MARK: ATCreateViewModelOutput
protocol ATCreateViewModelOutput {
    var selectedLocation: PublishRelay<MKMapItem> { get }
    var showedSelectedLabels: BehaviorRelay<[Flag]> { get }
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
    var _selectedLabels: [Flag] = []

    // MARK: Output ViewModel
    let selectedLocation = PublishRelay<MKMapItem>()
    let showedSelectedLabels = BehaviorRelay<[Flag]>(value: [])

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
    
    func presentFLListUI() {
        let response = FLListViewModelResponse()
        response.selectedFlags
            .do(onNext: { [unowned self] in
                self._selectedLabels = $0
            })
            .bind(to: self.showedSelectedLabels)
            .disposed(by: self.disposeBag)
        let selectedLabels = self._selectedLabels
        let request = FLListViewModelRequest(selectedFlags: selectedLabels)
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
