//
//  PFPersonalizeViewModel.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxRelay
import RxSwift

// MARK: PFPersonalizeViewModelResult
enum PFPersonalizeViewModelResult: Equatable {
    case DoCreate(AnyResult<String, String>)
    
    static func == (lhs: PFPersonalizeViewModelResult, rhs: PFPersonalizeViewModelResult) -> Bool {
        switch (lhs, rhs) {
        case (.DoCreate(let lhsRes), .DoCreate(let rhsRes)):
            switch (lhsRes, rhsRes) {
            case (.success(let lhsValue), .success(let rhsValue)):
                return lhsValue == rhsValue
            case (.failure(let lhsValue), .failure(let rhsValue)):
                return lhsValue == rhsValue
            default:
                return false
            }
        }
    }
}

// MARK: PFPersonalizeViewModelRequest
public struct PFPersonalizeViewModelRequest {
}

// MARK: PFPersonalizeViewModelResponse
public struct PFPersonalizeViewModelResponse {
    let controllerDidDismiss = PublishSubject<Void>()
}

// MARK: PFPersonalizeViewModelRoute
public struct PFPersonalizeViewModelRoute {
    var pushToLNPadUI: (() -> Void)?
}

// MARK: PFPersonalizeViewModelInput
protocol PFPersonalizeViewModelInput {
    func viewDidLoad()
    func controllerDidDismiss()
    func createBarButtonDidTap(dateOfBirth: Date,
                               firstName: String,
                               gender: Gender,
                               lastName: String,
                               mobileNumber: String,
                               photo: UIImage?)
    func pushToHDTimelineUI()
}

// MARK: PFPersonalizeViewModelOutput
protocol PFPersonalizeViewModelOutput {
    var result: PublishRelay<PFPersonalizeViewModelResult> { get }
    var showedCountryDialingCodes: BehaviorRelay<[CountryDialingCodeDomain]> { get }
}

// MARK: PFPersonalizeViewModel
protocol PFPersonalizeViewModel: PFPersonalizeViewModelInput,
                                 PFPersonalizeViewModelOutput,
                                 AnyObject { }

// MARK: DefaultPFPersonalizeViewModel
final class DefaultPFPersonalizeViewModel: PFPersonalizeViewModel {

    // MARK: DI Variable
    let request: PFPersonalizeViewModelRequest
    let response: PFPersonalizeViewModelResponse
    let route: PFPersonalizeViewModelRoute

    // MARK: UseCase Variable
    let createProfileUseCase: CreateProfileUseCase
    let fetchCountryDialingCodeUseCase: FetchCountryDialingCodeUseCase
    let setCurrentProfileUseCase: SetCurrentProfileUseCase

    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Output ViewModel
    let result = PublishRelay<PFPersonalizeViewModelResult>()
    let showedCountryDialingCodes = BehaviorRelay<[CountryDialingCodeDomain]>(value: [])

    // MARK: Init Function
    init(request: PFPersonalizeViewModelRequest,
         response: PFPersonalizeViewModelResponse,
         route: PFPersonalizeViewModelRoute,
         createProfileUseCase: CreateProfileUseCase,
         fetchCountryDialingCodeUseCase: FetchCountryDialingCodeUseCase,
         setCurrentProfileUseCase: SetCurrentProfileUseCase) {
        self.request = request
        self.response = response
        self.route = route
        self.createProfileUseCase = createProfileUseCase
        self.fetchCountryDialingCodeUseCase = fetchCountryDialingCodeUseCase
        self.setCurrentProfileUseCase = setCurrentProfileUseCase
    }
    
    func executeFetchCountryDialingCodeUseCase() -> Single<FetchCountryDialingCodeUseCaseResponse> {
        self.fetchCountryDialingCodeUseCase.execute(FetchCountryDialingCodeUseCaseRequest())
    }
    
}

// MARK: Input ViewModel
extension DefaultPFPersonalizeViewModel {
    
    func viewDidLoad() {
        self.executeFetchCountryDialingCodeUseCase()
            .subscribe(onSuccess: { [unowned self] (response) in
                let countryDialingCodes = response
                    .countryDialingCodes
                    .sorted(by: { $0.code < $1.code })
                self.showedCountryDialingCodes.accept(countryDialingCodes)
            })
            .disposed(by: self.disposeBag)
    }
    
    func controllerDidDismiss() {
        self.response.controllerDidDismiss.onNext(void)
    }
    
    func createBarButtonDidTap(dateOfBirth: Date,
                               firstName: String,
                               gender: Gender,
                               lastName: String,
                               mobileNumber: String,
                               photo: UIImage?) {
        let request = CreateProfileUseCaseRequest(dateOfBirth: dateOfBirth,
                                                  firstName: firstName,
                                                  gender: gender,
                                                  lastName: lastName,
                                                  mobileNumber: mobileNumber,
                                                  photo: photo)
        self.createProfileUseCase
            .execute(request)
            .map({ $0.profile })
            .flatMap({ [unowned self] (profile) -> Single<Profile> in
                let request = SetCurrentProfileUseCaseRequest(profile: profile)
                return self.setCurrentProfileUseCase.execute(request).map({ $0.profile })
            })
            .subscribe(onSuccess: { (profile) in
                let successMessage = "\(profile.fullName) has been created.\nWe hope you are always healthy 🥳"
                let success = AnyResult<String, String>.success(successMessage)
                let result = PFPersonalizeViewModelResult.DoCreate(success)
                self.result.accept(result)
            }, onFailure: { [unowned self] (error) in
                let failure = AnyResult<String, String>.failure(error.localizedDescription)
                let result = PFPersonalizeViewModelResult.DoCreate(failure)
                self.result.accept(result)
            })
            .disposed(by: self.disposeBag)
    }
    
    func pushToHDTimelineUI() {
        self.route.pushToLNPadUI?()
    }
    
}
