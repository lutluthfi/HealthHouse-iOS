//
//  AppDIContainer+RepositoryFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/04/21.
//

import Foundation

extension AppDIContainer: RepositoryFactory {
    
    func makeActivityRepository() -> ActivityRepository {
        return DefaultActivityRepository(localActivityStorage: self.localActivityStorage)
    }
    
    func makeAppConfigRepository() -> AppConfigRepository {
        return DefaultAppCofigRepository(localAppConfigStorage: self.localAppConfigStorage)
    }
    
    func makeCountryDialingCodeRepository() -> CountryDialingCodeRepository {
        return DefaultCountryDialingCodeRepository(remoteCountryDialingCodeStorage: self.remoteCountryDialingCodeStorage)
    }
    
    func makeFlagRepository() -> FlagRepository {
        return DefaultFlagRepository(localActivityFlagStorage: self.localActivityFlagStorage,
                                     localFlagStorage: self.localFlagStorage)
    }
    
    func makeProfileRepository() -> ProfileRepository {
        return DefaultProfileRepository(localProfileStorage: self.localProfileStorage)
    }
    
}
