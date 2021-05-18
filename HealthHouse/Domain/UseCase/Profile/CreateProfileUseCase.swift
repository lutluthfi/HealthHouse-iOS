//
//  CreateProfileUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 11/04/21.
//  Copyright (c) 2021 All rights reserved.

import RxSwift
import UIKit

public enum CreateProfileUseCaseError: LocalizedError {
    
}

extension CreateProfileUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct CreateProfileUseCaseResponse {
    
    public let profile: ProfileDomain
    
}

public struct CreateProfileUseCaseRequest {

    public let firstName: String
    public let dateOfBirth: Date
    public let gender: GenderDomain
    public let lastName: String
    public let mobileNumber: String
    public let photo: UIImage?
    
}

public protocol CreateProfileUseCase {
    
    func execute(_ request: CreateProfileUseCaseRequest) -> Observable<CreateProfileUseCaseResponse>

}

public final class DefaultCreateProfileUseCase {

    let profileRepository: ProfileRepository
    
    public init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

}

extension DefaultCreateProfileUseCase: CreateProfileUseCase {

    public func execute(_ request: CreateProfileUseCaseRequest) -> Observable<CreateProfileUseCaseResponse> {
        let profile = ProfileDomain.create(from: request)
        return self.profileRepository
            .insertUpdateProfile(profile, into: .coreData)
            .map { CreateProfileUseCaseResponse(profile: $0) }
    }
    
}

fileprivate extension ProfileDomain {
    
    static func create(from request: CreateProfileUseCaseRequest) -> ProfileDomain {
        let now = Date().toInt64()
        return ProfileDomain(coreID: nil,
                             createdAt: now,
                             updatedAt: now,
                             dateOfBirth: request.dateOfBirth.toInt64(),
                             firstName: request.firstName,
                             gender: request.gender,
                             lastName: request.lastName,
                             mobileNumbder: request.mobileNumber,
                             photoBase64String: request.photo?.pngData()?.base64EncodedString())
    }
    
}
