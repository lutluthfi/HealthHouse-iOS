//
//  AppDIContainer+AllergyUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/07/21.
//

import Foundation

extension AppDIContainer: AllergyUseCaseFactory {
    
    func makeCreateUpdateAllergyUseCase() -> CreateUpdateAllergyUseCase {
        return DefaultCreateUpdateAllergyUseCase(allergyRepository: self.makeAllergyRepository())
    }
    
}
