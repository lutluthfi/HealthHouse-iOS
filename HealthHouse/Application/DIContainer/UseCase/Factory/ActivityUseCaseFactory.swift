//
//  ActivityUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 21/04/21.
//

import Foundation

protocol ActivityUseCaseFactory {
    func makeCreateUpdateActivityUseCase() -> CreateUpdateActivityUseCase
    func makeFetchAllActivityByProfileUseCase() -> FetchAllActivityByProfileUseCase
}
