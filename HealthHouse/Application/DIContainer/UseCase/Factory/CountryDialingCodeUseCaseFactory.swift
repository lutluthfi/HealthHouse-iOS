//
//  CountryDialingCodeUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/04/21.
//

import Foundation

public protocol CountryDialingCodeUseCaseFactory {
    func makeFetchCountryDialingCodeUseCase() -> FetchCountryDialingCodeUseCase
}
