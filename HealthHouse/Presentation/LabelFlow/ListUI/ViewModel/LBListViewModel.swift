//
//  LBListViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/05/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxRelay
import RxSwift

// MARK: LBListViewModelResult
enum LBListViewModelResult {
}

// MARK: LBListViewModelResponse
public struct LBListViewModelResponse {
    public let selectedLabels = PublishRelay<[LabelDomain]>()
}

// MARK: LBListViewModelRequest
public struct LBListViewModelRequest {
    public let selectedLabels: [LabelDomain]
}

// MARK: LBListViewModelRoute
public struct LBListViewModelRoute {
    var presentLBCreateUI: ((LBCreateViewModelRequest, LBCreateViewModelResponse) -> Void)?
}

// MARK: LBListViewModelInput
protocol LBListViewModelInput {
    func viewDidLoad()
    func doDone(selectedLabels: [LabelDomain])
    func doRemove(label: LabelDomain)
    func doSelect(label: LabelDomain)
    func presentLBCreateUI()
}

// MARK: LBListViewModelOutput
protocol LBListViewModelOutput {
    var showedLabels: PublishRelay<[SelectableDomain<LabelDomain>]> { get }
}

// MARK: LBListViewModel
protocol LBListViewModel: LBListViewModelInput, LBListViewModelOutput { }

// MARK: DefaultLBListViewModel
final class DefaultLBListViewModel: LBListViewModel {
    
    // MARK: DI Variable
    let request: LBListViewModelRequest
    let response: LBListViewModelResponse
    let route: LBListViewModelRoute
    
    // MARK: UseCase Variable
    
    
    
    // MARK: Common Variable
    var _currSelectedLabels: [LabelDomain] = []
    
    // MARK: Output ViewModel
    let showedLabels = PublishRelay<[SelectableDomain<LabelDomain>]>()
    
    // MARK: Init Function
    init(request: LBListViewModelRequest,
         response: LBListViewModelResponse,
         route: LBListViewModelRoute) {
        self.request = request
        self.response = response
        self.route = route
    }
    
}

// MARK: Input ViewModel
extension DefaultLBListViewModel {
    
    func viewDidLoad() {
        let selectedLabels = self.request.selectedLabels
        let showedlabels = [LabelDomain(coreID: nil,
                                        createdAt: Date().toInt64(),
                                        updatedAt: Date().toInt64(),
                                        hexcolor: UIColor.red.hex,
                                        name: "Annual MCU"),
                            LabelDomain(coreID: nil,
                                        createdAt: Date().toInt64(),
                                        updatedAt: Date().toInt64(),
                                        hexcolor: UIColor.orange.hex,
                                        name: "Rontgen")]
        let showedSelectableLabels = showedlabels.map({
            SelectableDomain(identify: $0.name, selected: selectedLabels.contains($0), value: $0)
        })
        self.showedLabels.accept(showedSelectableLabels)
    }
    
    func doDone(selectedLabels: [LabelDomain]) {
        self.response.selectedLabels.accept(selectedLabels)
    }
    
    func doRemove(label: LabelDomain) {
    }
    
    func doSelect(label: LabelDomain) {
        guard !self._currSelectedLabels.contains(label) else { return }
        self._currSelectedLabels.append(label)
    }
    
    func presentLBCreateUI() {
        let request = LBCreateViewModelRequest()
        let response = LBCreateViewModelResponse()
        self.route.presentLBCreateUI?(request, response)
    }
    
}
