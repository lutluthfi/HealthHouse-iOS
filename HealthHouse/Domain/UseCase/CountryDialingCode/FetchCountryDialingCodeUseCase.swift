//
//  FetchCountryDialingCodeUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxSwift

enum FetchCountryDialingCodeUseCaseError: LocalizedError {
    
}

extension FetchCountryDialingCodeUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct FetchCountryDialingCodeUseCaseResponse {
    
    let countryDialingCodes: [CountryDialingCodeDomain]
    
}

struct FetchCountryDialingCodeUseCaseRequest {

}

protocol FetchCountryDialingCodeUseCase {
    
    func execute(_ request: FetchCountryDialingCodeUseCaseRequest) -> Single<FetchCountryDialingCodeUseCaseResponse>

}

final class DefaultFetchCountryDialingCodeUseCase {

    let countryDialingCodeRepository: CountryDialingCodeRepository
    
    init(countryDialingCodeRepository: CountryDialingCodeRepository) {
        self.countryDialingCodeRepository = countryDialingCodeRepository
    }

}

extension DefaultFetchCountryDialingCodeUseCase: FetchCountryDialingCodeUseCase {

    func execute(_ request: FetchCountryDialingCodeUseCaseRequest) -> Single<FetchCountryDialingCodeUseCaseResponse> {
        self.countryDialingCodeRepository
            .fetchAllCountryDialingCode(in: .remote)
            .map { FetchCountryDialingCodeUseCaseResponse(countryDialingCodes: $0) }
    }
    
}
