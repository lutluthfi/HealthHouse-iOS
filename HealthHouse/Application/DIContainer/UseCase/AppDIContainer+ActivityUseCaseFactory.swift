//
//  AppDIContainer+ActivityUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 21/04/21.
//

import Foundation

extension AppDIContainer: ActivityUseCaseFactory {
    
    public func makeCreateUpdateActivityUseCase() -> CreateUpdateActivityUseCase {
        return DefaultCreateUpdateActivityUseCase(activityRepository: self.makeActivityRepository())
    }
    
    public func makeFetchAllActivityByProfileUseCase() -> FetchAllActivityByProfileUseCase {
        return DefaultFetchAllActivityByProfileUseCase(activityRepository: self.makeActivityRepository())
    }
    
}
