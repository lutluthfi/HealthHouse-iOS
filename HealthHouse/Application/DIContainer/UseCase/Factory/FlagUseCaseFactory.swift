//
//  FlagUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import Foundation

protocol FlagUseCaseFactory {
    func makeCreateFlagUseCase() -> CreateFlagUseCase
    func makeFetchAllFlagUseCase() -> FetchAllFlagUseCase
}
