//
//  AppDIContainer+ProfileUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 19/04/21.
//

import Foundation

extension AppDIContainer: ProfileUseCaseFactory {
    
    public func makeCreateProfileUseCase() -> CreateProfileUseCase {
        return DefaultCreateProfileUseCase(profileRepository: self.makeProfileRepository())
    }
    
    public func makeFetchCurrentProfileUseCase() -> FetchCurrentProfileUseCase {
        return DefaultFetchCurrentProfileUseCase(profileRepository: self.makeProfileRepository())
    }
    
    public func makeSetCurrentProfileUseCase() -> SetCurrentProfileUseCase {
        return DefaultSetCurrentProfileUseCase(profileRepository: self.makeProfileRepository())
    }
    
}
