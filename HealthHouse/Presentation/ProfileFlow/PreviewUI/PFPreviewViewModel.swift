//
//  PFPreviewViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxRelay
import RxSwift

// MARK: PFPreviewViewModelResult
enum PFPreviewViewModelResult {
}

// MARK: PFPreviewViewModelRequest
public struct PFPreviewViewModelRequest {
}

// MARK: PFPreviewViewModelResponse
public struct PFPreviewViewModelResponse {
    
}

// MARK: PFPreviewViewModelRoute
public struct PFPreviewViewModelRoute {
}

// MARK: PFPreviewViewModelInput
protocol PFPreviewViewModelInput {
    func viewDidLoad()
    func viewDidAppear()
}

// MARK: PFPreviewViewModelOutput
protocol PFPreviewViewModelOutput {
    var loadingState: PublishRelay<LoadingState> { get }
    var showedProfile: PublishRelay<Profile?> { get }
}

// MARK: PFPreviewViewModel
protocol PFPreviewViewModel: PFPreviewViewModelInput, PFPreviewViewModelOutput { }

// MARK: DefaultPFPreviewViewModel
final class DefaultPFPreviewViewModel: PFPreviewViewModel {

    // MARK: DI Variable
    let request: PFPreviewViewModelRequest
    let route: PFPreviewViewModelRoute

    // MARK: UseCase Variable
    let fetchCurrentProfileUseCase: FetchCurrentProfileUseCase

    // MARK: Common Variable
    let diposeBag = DisposeBag()
    

    // MARK: Output ViewModel
    let loadingState = PublishRelay<LoadingState>()
    let showedProfile = PublishRelay<Profile?>()

    // MARK: Init Function
    init(request: PFPreviewViewModelRequest,
         route: PFPreviewViewModelRoute,
         fetchCurrentProfileUseCase: FetchCurrentProfileUseCase) {
        self.request = request
        self.route = route
        self.fetchCurrentProfileUseCase = fetchCurrentProfileUseCase
    }
    
}

// MARK: Input ViewModel
extension DefaultPFPreviewViewModel {
    
    func viewDidLoad() {
    }
    
    func viewDidAppear() {
        self.loadingState.accept(.willShow)
        self.fetchCurrentProfileUseCase
            .execute(FetchCurrentProfileUseCaseRequest())
            .filter({ $0.profile != nil })
            .compactMap({ $0.profile })
            .subscribe(onSuccess: { [weak self] (profile) in
                self?.loadingState.accept(.willHide)
                self?.showedProfile.accept(profile)
            })
            .disposed(by: self.diposeBag)
    }
    
}
