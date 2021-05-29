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
    public let selectedFlags = PublishRelay<[FlagDomain]>()
}

// MARK: FLListViewModelRequest
public struct FLListViewModelRequest {
    public let selectedFlags: [FlagDomain]
}

// MARK: FLListViewModelRoute
public struct FLListViewModelRoute {
    var presentLBCreateUI: ((FLCreateViewModelRequest, FLCreateViewModelResponse) -> Void)?
}

// MARK: FLListViewModelInput
protocol FLListViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func doDone(selectedLabels: [FlagDomain])
    func doRemove(label: FlagDomain)
    func doSelect(label: FlagDomain)
    func presentLBCreateUI()
}

// MARK: FLListViewModelOutput
protocol FLListViewModelOutput {
    var showedFlags: PublishRelay<[SelectableDomain<FlagDomain>]> { get }
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
    let fetchAllFlagUseCase: FetchAllFlagUseCase
    let fetchProfileUseCase: FetchCurrentProfileUseCase
    
    // MARK: Common Variable
    lazy var disposeBag = DisposeBag()
    var _currSelectedLabels: [FlagDomain] = []
    
    // MARK: Output ViewModel
    let showedFlags = PublishRelay<[SelectableDomain<FlagDomain>]>()
    
    // MARK: Init Function
    init(request: FLListViewModelRequest,
         response: FLListViewModelResponse,
         route: FLListViewModelRoute,
         fetchAllFlagUseCase: FetchAllFlagUseCase,
         fetchProfileUseCase: FetchCurrentProfileUseCase) {
        self.request = request
        self.response = response
        self.route = route
        self.fetchAllFlagUseCase = fetchAllFlagUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
    }
    
    func doFetchCurrentProfileUseCase() -> Observable<FetchCurrentProfileUseCaseResponse> {
        let request = FetchCurrentProfileUseCaseRequest()
        return self.fetchProfileUseCase.execute(request)
    }
    
    func doFetchAllFlaguseCase(ownedBy profile: ProfileDomain) -> Observable<FetchAllFlagUseCaseResponse> {
        let request = FetchAllFlagUseCaseRequest(ownedBy: profile)
        return self.fetchAllFlagUseCase.execute(request)
    }
    
}

// MARK: Input ViewModel
extension DefaultFLListViewModel {
    
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        let selectedFlags = self.request.selectedFlags
        self.doFetchCurrentProfileUseCase()
            .compactMap({ $0.profile })
            .flatMap(self.doFetchAllFlaguseCase(ownedBy:))
            .map({ $0.flags.map({ SelectableDomain(identify: $0.name,
                                                   selected: selectedFlags.contains($0),
                                                   value: $0) }) })
            .bind(to: self.showedFlags)
            .disposed(by: self.disposeBag)
    }
    
    func doDone(selectedLabels: [FlagDomain]) {
        self.response.selectedFlags.accept(selectedLabels)
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
