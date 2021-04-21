//
//  AppDIContainer+ProfileUseCaseFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 19/04/21.
//

import Foundation

extension AppDIContainer: ProfileUseCaseFactory {
    
    public func makeCreateProfileUseCase() -> CreateProfileUseCase {
        return DefaultCreateProfileUseCase(profileRepository: self.makeProfileRepository())
    }
    
}
