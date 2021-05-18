//
//  AppDIContainer+FlagUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import Foundation

extension AppDIContainer: FlagUseCaseFactory {
    
    public func makeCreateUpdateFlagUseCase() -> CreateUpdateFlagUseCase {
        return DefaultCreateUpdateFlagUseCase(flagRepository: self.makeFlagRepository())
    }
    
}
