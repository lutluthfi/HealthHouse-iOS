//
//  FLListViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxRelay
import RxSwift

// MARK: FLListViewModelResult
enum FLListViewModelResult {
}

// MARK: FLListViewModelResponse
public struct FLListViewModelResponse {
    public let selectedLabels = PublishRelay<[FlagDomain]>()
}

// MARK: FLListViewModelRequest
public struct FLListViewModelRequest {
    public let selectedLabels: [FlagDomain]
}

// MARK: FLListViewModelRoute
public struct FLListViewModelRoute {
    var presentLBCreateUI: ((FLCreateViewModelRequest, FLCreateViewModelResponse) -> Void)?
}

// MARK: FLListViewModelInput
protocol FLListViewModelInput {
    func viewDidLoad()
    func doDone(selectedLabels: [FlagDomain])
    func doRemove(label: FlagDomain)
    func doSelect(label: FlagDomain)
    func presentLBCreateUI()
}

// MARK: FLListViewModelOutput
protocol FLListViewModelOutput {
    var showedLabels: PublishRelay<[SelectableDomain<FlagDomain>]> { get }
}

// MARK: FLListViewModel
protocol FLListViewModel: FLListViewModelInput, FLListViewModelOutput { }

// MARK: DefaultFLListViewModel
final class DefaultFLListViewModel: FLListViewModel {
    
    // MARK: DI Variable
    let request: FLListViewModelRequest
    let response: FLListViewModelResponse
    let route: FLListViewModelRoute
    
    // MARK: UseCase Variable
    
    
    
    // MARK: Common Variable
    var _currSelectedLabels: [FlagDomain] = []
    
    // MARK: Output ViewModel
    let showedLabels = PublishRelay<[SelectableDomain<FlagDomain>]>()
    
    // MARK: Init Function
    init(request: FLListViewModelRequest,
         response: FLListViewModelResponse,
         route: FLListViewModelRoute) {
        self.request = request
        self.response = response
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultFLListViewModel {
    
    func viewDidLoad() {
        let selectedLabels = self.request.selectedLabels
        let showedlabels = [FlagDomain(coreID: nil,
                                        createdAt: Date().toInt64(),
                                        updatedAt: Date().toInt64(),
                                        hexcolor: UIColor.red.hex,
                                        name: "Annual MCU"),
                            FlagDomain(coreID: nil,
                                        createdAt: Date().toInt64(),
                                        updatedAt: Date().toInt64(),
                                        hexcolor: UIColor.orange.hex,
                                        name: "Rontgen")]
        let showedSelectableLabels = showedlabels.map({
            SelectableDomain(identify: $0.name, selected: selectedLabels.contains($0), value: $0)
        })
        self.showedLabels.accept(showedSelectableLabels)
    }
    
    func doDone(selectedLabels: [FlagDomain]) {
        self.response.selectedLabels.accept(selectedLabels)
    }
    
    func doRemove(label: FlagDomain) {
    }
    
    func doSelect(label: FlagDomain) {
        guard !self._currSelectedLabels.contains(label) else { return }
        self._currSelectedLabels.append(label)
    }
    
    func presentLBCreateUI() {
        let request = FLCreateViewModelRequest()
        let response = FLCreateViewModelResponse()
        self.route.presentLBCreateUI?(request, response)
    }
    
}
