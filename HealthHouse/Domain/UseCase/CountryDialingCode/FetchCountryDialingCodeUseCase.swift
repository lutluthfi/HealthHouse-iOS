//
//  FetchCountryDialingCodeUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxSwift

public enum FetchCountryDialingCodeUseCaseError: LocalizedError {
    
}

extension FetchCountryDialingCodeUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct FetchCountryDialingCodeUseCaseResponse {
    
    public let countryDialingCodes: [CountryDialingCodeDomain]
    
}

public struct FetchCountryDialingCodeUseCaseRequest {

}

public protocol FetchCountryDialingCodeUseCase {
    
    func execute(_ request: FetchCountryDialingCodeUseCaseRequest) -> Observable<FetchCountryDialingCodeUseCaseResponse>

}

public final class DefaultFetchCountryDialingCodeUseCase {

    let countryDialingCodeRepository: CountryDialingCodeRepository
    
    public init(countryDialingCodeRepository: CountryDialingCodeRepository) {
        self.countryDialingCodeRepository = countryDialingCodeRepository
    }

}

extension DefaultFetchCountryDialingCodeUseCase: FetchCountryDialingCodeUseCase {

    public func execute(_ request: FetchCountryDialingCodeUseCaseRequest) -> Observable<FetchCountryDialingCodeUseCaseResponse> {
        self.countryDialingCodeRepository
            .fetchAllCountryDialingCode(in: .remote)
            .map { FetchCountryDialingCodeUseCaseResponse(countryDialingCodes: $0) }
    }
    
}
