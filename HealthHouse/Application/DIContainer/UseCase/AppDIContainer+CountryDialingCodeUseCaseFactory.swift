//
//  AppDIContainer+CountryDialingCodeUseCaseFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 11/04/21.
//

import Foundation

extension AppDIContainer: CountryDialingCodeUseCaseFactory {
    
    public func makeFetchCountryDialingCodeUseCase() -> FetchCountryDialingCodeUseCase {
        return DefaultFetchCountryDialingCodeUseCase(countryDialingCodeRepository: self.makeCountryDialingCodeRepository())
    }
    
}
