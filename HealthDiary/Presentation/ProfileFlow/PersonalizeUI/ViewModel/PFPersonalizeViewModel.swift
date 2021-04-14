//
//  PFPersonalizeViewModel.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxSwift

// MARK: PFPersonalizeViewModelResponse
enum PFPersonalizeViewModelResponse {
}

// MARK: PFPersonalizeViewModelDelegate
protocol PFPersonalizeViewModelDelegate: class {
}

// MARK: PFPersonalizeViewModelRequestValue
public struct PFPersonalizeViewModelRequestValue {
}

// MARK: PFPersonalizeViewModelRoute
public struct PFPersonalizeViewModelRoute {
    
}

// MARK: PFPersonalizeViewModelInput
protocol PFPersonalizeViewModelInput {

    func viewDidLoad()
    func doCreate(firstName: String?,
                  lastName: String?,
                  dateOfBirth: Date?,
                  gender: GenderDomain?,
                  mobileNumber: String?)

}

// MARK: PFPersonalizeViewModelOutput
protocol PFPersonalizeViewModelOutput {
    
    var showedCountryDialingCodes: PublishSubject<[CountryDialingCodeDomain]> { get }
    
}

// MARK: PFPersonalizeViewModel
protocol PFPersonalizeViewModel: PFPersonalizeViewModelInput, PFPersonalizeViewModelOutput { }

// MARK: DefaultPFPersonalizeViewModel
final class DefaultPFPersonalizeViewModel: PFPersonalizeViewModel {

    // MARK: DI Variable
    weak var delegate: PFPersonalizeViewModelDelegate?
    let requestValue: PFPersonalizeViewModelRequestValue
    let route: PFPersonalizeViewModelRoute

    // MARK: UseCase Variable
    let fetchCountryDialingCodeUseCase: FetchCountryDialingCodeUseCase

    // MARK: Common Variable
    let disposeBag = DisposeBag()

    // MARK: Output ViewModel
    let showedCountryDialingCodes = PublishSubject<[CountryDialingCodeDomain]>()

    // MARK: Init Function
    init(requestValue: PFPersonalizeViewModelRequestValue,
         route: PFPersonalizeViewModelRoute,
         fetchCountryDialingCodeUseCase: FetchCountryDialingCodeUseCase) {
        self.requestValue = requestValue
        self.route = route
        self.fetchCountryDialingCodeUseCase = fetchCountryDialingCodeUseCase
    }
    
}

// MARK: Input ViewModel
extension DefaultPFPersonalizeViewModel {
    
    func viewDidLoad() {
        self.subscribeFetchCountryDialingCodeUseCase(self.fetchCountryDialingCodeUseCase,
                                                     subject: self.showedCountryDialingCodes)
    }
    
    func doCreate(firstName: String?,
                  lastName: String?,
                  dateOfBirth: Date?,
                  gender: GenderDomain?,
                  mobileNumber: String?) {
        
    }
    
}

extension DefaultPFPersonalizeViewModel {
    
    func subscribeFetchCountryDialingCodeUseCase(_ useCase: FetchCountryDialingCodeUseCase,
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
