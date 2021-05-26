//
//  AppDIContainer+FlagUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import Foundation

extension AppDIContainer: FlagUseCaseFactory {
    
    public func makeCreateUpdateFlagUseCase() -> CreateFlagUseCase {
        return DefaultCreateFlagUseCase(flagRepository: self.makeFlagRepository())
    }
    
    public func makeFetchAllFlagUseCase() -> FetchAllFlagUseCase {
        return DefaultFetchAllFlagUseCase(flagRepository: self.makeFlagRepository())
    }
    
}
