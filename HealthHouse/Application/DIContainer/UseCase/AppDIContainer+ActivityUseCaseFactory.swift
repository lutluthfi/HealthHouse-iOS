//
//  AppDIContainer+ActivityUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 21/04/21.
//

import Foundation

extension AppDIContainer: ActivityUseCaseFactory {
    
    func makeCreateUpdateActivityUseCase() -> CreateUpdateActivityUseCase {
        return DefaultCreateUpdateActivityUseCase(activityRepository: self.makeActivityRepository())
    }
    
    func makeFetchAllActivityByProfileUseCase() -> FetchAllActivityByProfileUseCase {
        return DefaultFetchAllActivityByProfileUseCase(activityRepository: self.makeActivityRepository())
    }
    
    func makeFetchAllActivityProfileByDoDateUseCase() -> FetchAllActivityProfileByDoDateUseCase {
        return DefaultFetchAllActivityProfileByDoDateUseCase(activityRepository: self.makeActivityRepository())
    }
    
}
