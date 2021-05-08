//
//  AppDIContainer+RepositoryFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/04/21.
//

import Foundation

extension AppDIContainer: RepositoryFactory {
    
    public func makeActivityRepository() -> ActivityRepository {
        return DefaultActivityRepository(localActivityStorage: self.localActivityStorage)
    }
    
    public func makeCountryDialingCodeRepository() -> CountryDialingCodeRepository {
        return DefaultCountryDialingCodeRepository(remoteCountryDialingCodeStorage: self.remoteCountryDialingCodeStorage)
    }
    
    public func makeProfileRepository() -> ProfileRepository {
        return DefaultProfileRepository(localProfileStorage: self.localProfileStorage)
    }
    
}
