//
//  CreateProfileUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxSwift
import UIKit

enum CreateProfileUseCaseError: LocalizedError {
    
}

extension CreateProfileUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct CreateProfileUseCaseResponse {
    
    let profile: Profile
    
}

struct CreateProfileUseCaseRequest {
    
    let dateOfBirth: Date
    let firstName: String
    let gender: Gender
    let lastName: String
    let mobileNumber: String
    let photo: UIImage?
    
}

protocol CreateProfileUseCase {
    
    func execute(_ request: CreateProfileUseCaseRequest) -> Single<CreateProfileUseCaseResponse>
    
}

final class DefaultCreateProfileUseCase {
    
    let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
}

extension DefaultCreateProfileUseCase: CreateProfileUseCase {
    
    func execute(_ request: CreateProfileUseCaseRequest) -> Single<CreateProfileUseCaseResponse> {
        let profile = Profile.create(from: request)
        return self.profileRepository
            .insertProfile(profile, into: .realm)
            .map({ CreateProfileUseCaseResponse(profile: $0) })
    }
    
}

fileprivate extension Profile {
    
    static func create(from request: CreateProfileUseCaseRequest) -> Profile {
        let now = Date().toInt64()
        return Profile(realmID: String.nil.orMakePrimaryKey,
                       createdAt: now,
                       updatedAt: now,
                       dateOfBirth: request.dateOfBirth.toInt64(),
                       firstName: request.firstName,
                       gender: request.gender,
                       lastName: request.lastName,
                       mobileNumbder: request.mobileNumber,
                       photoBase64String: request.photo?.pngData()?.base64EncodedString(),
                       allergies: [])
    }
    
}

extension String {
    
    static var `nil`: String? {
        return nil
    }
    
}
