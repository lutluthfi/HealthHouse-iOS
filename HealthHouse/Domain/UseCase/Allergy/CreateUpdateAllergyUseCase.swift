//
//  CreateUpdateAllergyUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/07/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

enum CreateUpdateAllergyUseCaseError: LocalizedError {
    
}

extension CreateUpdateAllergyUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct CreateUpdateAllergyUseCaseResponse {
    let allergy: Allergy
}

struct CreateUpdateAllergyUseCaseRequest {
    
    let allergyID: AllergyID?
    let allergyCase: String
    let allergyEffect: String
    let profile: Profile
    
    init(allergyID: AllergyID?,
         allergyCase: String,
         allergyEffect: String,
         ownedBy profile: Profile) {
        self.allergyID = allergyID
        self.allergyCase = allergyCase
        self.allergyEffect = allergyEffect
        self.profile = profile
    }
    
}

protocol CreateUpdateAllergyUseCase {
    func execute(_ request: CreateUpdateAllergyUseCaseRequest) -> Single<CreateUpdateAllergyUseCaseResponse>
}

final class DefaultCreateUpdateAllergyUseCase {

    let allergyRepository: AllergyRepository
    
    init(allergyRepository: AllergyRepository) {
        self.allergyRepository = allergyRepository
    }

}

extension DefaultCreateUpdateAllergyUseCase: CreateUpdateAllergyUseCase {

    func execute(_ request: CreateUpdateAllergyUseCaseRequest) -> Single<CreateUpdateAllergyUseCaseResponse> {
        let allergy = Allergy.make(from: request)
        let profile = Profile.make(from: request)
        return self.allergyRepository
            .insertUpdateAllergy(allergy, ownedBy: profile, into: .realm)
            .map { CreateUpdateAllergyUseCaseResponse(allergy: $0) }
    }
    
}

fileprivate extension Allergy {
    
    static func make(from request: CreateUpdateAllergyUseCaseRequest) -> Allergy {
        let now = Date().toInt64()
        return Allergy(realmID: request.allergyID.orMakePrimaryKey,
                       createdAt: now,
                       updatedAt: now,
                       cause: request.allergyCase,
                       effect: request.allergyEffect)
    }
    
}

fileprivate extension Profile {
    
    static func make(from request: CreateUpdateAllergyUseCaseRequest) -> Profile {
        let now = Date().toInt64()
        let newAllergy = Allergy.make(from: request)
        var profileAllergies = request.profile.allergies
        profileAllergies.append(newAllergy)
        return Profile(realmID: request.profile.realmID,
                       createdAt: now,
                       updatedAt: now,
                       dateOfBirth: request.profile.dateOfBirth,
                       firstName: request.profile.firstName,
                       gender: request.profile.gender,
                       lastName: request.profile.lastName,
                       mobileNumbder: request.profile.mobileNumbder,
                       photoBase64String: request.profile.photoBase64String,
                       allergies: profileAllergies)
    }
    
}
