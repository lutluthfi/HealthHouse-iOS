//
//  RepositoryFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation

protocol RepositoryFactory {
    func makeActivityRepository() -> ActivityRepository
    func makeAllergyRepository() -> AllergyRepository
    func makeAppConfigRepository() -> AppConfigRepository
    func makeCountryDialingCodeRepository() -> CountryDialingCodeRepository
    func makeFlagRepository() -> FlagRepository
    func makeProfileRepository() -> ProfileRepository
}
