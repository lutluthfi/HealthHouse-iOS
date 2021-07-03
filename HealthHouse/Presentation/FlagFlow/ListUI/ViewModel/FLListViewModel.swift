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
struct FLListViewModelResponse {
    let selectedFlags = PublishRelay<[Flag]>()
}

// MARK: FLListViewModelRequest
struct FLListViewModelRequest {
    let selectedFlags: [Flag]
}

// MARK: FLListViewModelRoute
struct FLListViewModelRoute {
    var presentLBCreateUI: ((FLCreateViewModelRequest, FLCreateViewModelResponse) -> Void)?
}

// MARK: FLListViewModelInput
protocol FLListViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func doDone(selectedLabels: [Flag])
    func doRemove(label: Flag)
    func doSelect(label: Flag)
    func presentLBCreateUI()
}

// MARK: FLListViewModelOutput
protocol FLListViewModelOutput {
    var showedFlags: PublishRelay<[SelectableDomain<Flag>]> { get }
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
    var _currSelectedLabels: [Flag] = []
    
    // MARK: Output ViewModel
    let showedFlags = PublishRelay<[SelectableDomain<Flag>]>()
    
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
        return self.fetchProfileUseCase.execute(request).asObservable()
    }
    
    func doFetchAllFlaguseCase(ownedBy profile: Profile) -> Observable<FetchAllFlagUseCaseResponse> {
        let request = FetchAllFlagUseCaseRequest(ownedBy: profile)
        return self.fetchAllFlagUseCase.execute(request).asObservable()
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
            .map({ $0.flags.toSelectableItems(selectedFlags: selectedFlags) })
            .bind(onNext: { flags in
                self.showedFlags.accept(flags)
            })
            .disposed(by: self.disposeBag)
    }
    
    func doDone(selectedLabels: [Flag]) {
        self.response.selectedFlags.accept(selectedLabels)
    }
    
    func doRemove(label: Flag) {
    }
    
    func doSelect(label: Flag) {
        guard !self._currSelectedLabels.contains(label) else { return }
        self._currSelectedLabels.append(label)
    }
    
    func presentLBCreateUI() {
        let request = FLCreateViewModelRequest()
        let response = FLCreateViewModelResponse()
        response
            .viewDidDismiss
            .bind { [unowned self] in
                self.viewWillAppear()
            }
            .disposed(by: self.disposeBag)
        self.route.presentLBCreateUI?(request, response)
    }
    
}
