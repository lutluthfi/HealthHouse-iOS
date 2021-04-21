//
//  RepositoryFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation

public protocol RepositoryFactory {
    
    func makeCountryDialingCodeRepository() -> CountryDialingCodeRepository
    
    func makeProfileRepository() -> ProfileRepository
    
}
