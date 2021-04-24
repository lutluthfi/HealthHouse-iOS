//
//  AppDIContainer+ActivityUseCaseFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 21/04/21.
//

import Foundation

extension AppDIContainer: ActivityUseCaseFactory {
    
    public func makeCreateActivityUseCase() -> CreateActivityUseCase {
        return DefaultCreateActivityUseCase()
    }
    
    public func makeFetchAllActivityUseCase() -> FetchAllActivityUseCase {
        return DefaultFetchAllActivityUseCase(activityRepository: self.makeActivityRepository())
    }
    
}
