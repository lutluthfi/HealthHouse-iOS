//
//  AppDIContainer+ProfileUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 19/04/21.
//

import Foundation

extension AppDIContainer: ProfileUseCaseFactory {
    
    func makeCreateProfileUseCase() -> CreateProfileUseCase {
        return DefaultCreateProfileUseCase(profileRepository: self.makeProfileRepository())
    }
    
    func makeFetchCurrentProfileUseCase() -> FetchCurrentProfileUseCase {
        return DefaultFetchCurrentProfileUseCase(profileRepository: self.makeProfileRepository())
    }
    
    func makeSetCurrentProfileUseCase() -> SetCurrentProfileUseCase {
        return DefaultSetCurrentProfileUseCase(profileRepository: self.makeProfileRepository())
    }
    
}
