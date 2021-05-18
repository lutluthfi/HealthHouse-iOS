//
//  RepositoryFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation

public protocol RepositoryFactory {
    func makeActivityRepository() -> ActivityRepository
    func makeCountryDialingCodeRepository() -> CountryDialingCodeRepository
    func makeFlagRepository() -> FlagRepository
    func makeProfileRepository() -> ProfileRepository
}
