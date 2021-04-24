//
//  PFPersonalizeViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxSwift

// MARK: PFPersonalizeViewModelResponse
enum PFPersonalizeViewModelResponse: Equatable {
    case DoCreate(AnyResult<String, String>)
    
    static func == (lhs: PFPersonalizeViewModelResponse, rhs: PFPersonalizeViewModelResponse) -> Bool {
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

// MARK: PFPersonalizeViewModelDelegate
protocol PFPersonalizeViewModelDelegate: AnyObject {
}

// MARK: PFPersonalizeViewModelRequest
public struct PFPersonalizeViewModelRequest {
}

// MARK: PFPersonalizeViewModelRoute
public struct PFPersonalizeViewModelRoute {
    
}

// MARK: PFPersonalizeViewModelInput
protocol PFPersonalizeViewModelInput {

    func viewDidLoad()
    func doCreate(firstName: String,
                  dateOfBirth: Date,
                  gender: GenderDomain,
                  lastName: String,
                  mobileNumber: String,
                  photo: UIImage?)

}

// MARK: PFPersonalizeViewModelOutput
protocol PFPersonalizeViewModelOutput {
    
    var response: PublishSubject<PFPersonalizeViewModelResponse> { get }
    var showedCountryDialingCodes: PublishSubject<[CountryDialingCodeDomain]> { get }
    
}

// MARK: PFPersonalizeViewModel
protocol PFPersonalizeViewModel: PFPersonalizeViewModelInput, PFPersonalizeViewModelOutput, AnyObject { }

// MARK: DefaultPFPersonalizeViewModel
final class DefaultPFPersonalizeViewModel: PFPersonalizeViewModel {

    // MARK: DI Variable
    weak var delegate: PFPersonalizeViewModelDelegate?
    let request: PFPersonalizeViewModelRequest
    let route: PFPersonalizeViewModelRoute

    // MARK: UseCase Variable
    let createProfileUseCase: CreateProfileUseCase
    let fetchCountryDialingCodeUseCase: FetchCountryDialingCodeUseCase

    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Output ViewModel
    let response = PublishSubject<PFPersonalizeViewModelResponse>()
    let showedCountryDialingCodes = PublishSubject<[CountryDialingCodeDomain]>()

    // MARK: Init Function
    init(request: PFPersonalizeViewModelRequest,
         route: PFPersonalizeViewModelRoute,
         createProfileUseCase: CreateProfileUseCase,
         fetchCountryDialingCodeUseCase: FetchCountryDialingCodeUseCase) {
        self.request = request
        self.route = route
        self.createProfileUseCase = createProfileUseCase
        self.fetchCountryDialingCodeUseCase = fetchCountryDialingCodeUseCase
    }
    
}

// MARK: Input ViewModel
extension DefaultPFPersonalizeViewModel {
    
    func viewDidLoad() {
        self.subscribeFetchCountryDialingCodeUseCase(useCase: self.fetchCountryDialingCodeUseCase,
                                                     subject: self.showedCountryDialingCodes)
    }
    
    func doCreate(firstName: String,
                  dateOfBirth: Date,
                  gender: GenderDomain,
                  lastName: String,
                  mobileNumber: String,
                  photo: UIImage?) {
        let request = CreateProfileUseCaseRequest(firstName: firstName,
                                                  dateOfBirth: dateOfBirth,
                                                  gender: gender,
                                                  lastName: lastName,
                                                  mobileNumber: mobileNumber,
                                                  photo: photo)
        self.createProfileUseCase
            .execute(request)
            .subscribe(onNext: { (response) in
                let profile = response.profile
                let successMessage = "\(profile.fullName) has been created.\nWe hope you are always healthy 🥳"
                let success = AnyResult<String, String>.success(successMessage)
                let response = PFPersonalizeViewModelResponse.DoCreate(success)
                self.response.onNext(response)
            }, onError: { [unowned self] (error) in
                let failure = AnyResult<String, String>.failure(error.localizedDescription)
                let response = PFPersonalizeViewModelResponse.DoCreate(failure)
                self.response.onNext(response)
            })
            .disposed(by: self.disposeBag)
    }
    
}

extension DefaultPFPersonalizeViewModel {
    
    func subscribeFetchCountryDialingCodeUseCase(useCase: FetchCountryDialingCodeUseCase,
                                                 subject: PublishSubject<[CountryDialingCodeDomain]>) {
        useCase
            .execute(FetchCountryDialingCodeUseCaseRequest())
            .subscribe(onNext: { [unowned subject] (response) in
                let countryDialingCodes = response
                    .countryDialingCodes
                    .sorted(by: { $0.code < $1.code })
                subject.onNext(countryDialingCodes)
            })
            .disposed(by: self.disposeBag)
    }
    
}
