//
//  CountryDialingCodeUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/04/21.
//

import Foundation

protocol CountryDialingCodeUseCaseFactory {
    func makeFetchCountryDialingCodeUseCase() -> FetchCountryDialingCodeUseCase
}
