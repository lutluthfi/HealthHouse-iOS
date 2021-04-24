//
//  ProfileUseCaseFactory.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 19/04/21.
//

import Foundation

public protocol ProfileUseCaseFactory {
    
    func makeCreateProfileUseCase() -> CreateProfileUseCase
    
}
