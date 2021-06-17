//
//  ProfileUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 19/04/21.
//

import Foundation

protocol ProfileUseCaseFactory {
    func makeCreateProfileUseCase() -> CreateProfileUseCase
    func makeFetchCurrentProfileUseCase() -> FetchCurrentProfileUseCase
    func makeSetCurrentProfileUseCase() -> SetCurrentProfileUseCase
}
