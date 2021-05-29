//
//  AppConfigUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 30/05/21.
//

import Foundation

public protocol AppConfigUseCaseFactory {
    func makeUpdateAppConfigFirstLaunchUseCase() -> UpdateAppConfigFirstLaunchUseCase
}
