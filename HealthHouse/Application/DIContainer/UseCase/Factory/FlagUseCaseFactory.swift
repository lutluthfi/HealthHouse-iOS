//
//  FlagUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import Foundation

public protocol FlagUseCaseFactory {
    func makeCreateUpdateFlagUseCase() -> CreateUpdateFlagUseCase
}
