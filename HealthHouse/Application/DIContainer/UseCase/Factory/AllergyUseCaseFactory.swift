//
//  AllergyUseCaseFactory.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/07/21.
//

import Foundation

protocol AllergyUseCaseFactory {
    
    func makeCreateUpdateAllergyUseCase() -> CreateUpdateAllergyUseCase
    
}
