//
//  AppDIContainer+AppConfigUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 30/05/21.
//

import Foundation

extension AppDIContainer: AppConfigUseCaseFactory {
    
    public func makeUpdateAppConfigFirstLaunchUseCase() -> UpdateAppConfigFirstLaunchUseCase {
        return DefaultUpdateAppConfigFirstLaunchUseCase(appConfigRepository: self.makeAppConfigRepository())
    }
    
}
