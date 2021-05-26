//
//  SetCurrentProfileUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 26/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum SetCurrentProfileUseCaseError: LocalizedError {
    
}

extension SetCurrentProfileUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct SetCurrentProfileUseCaseResponse {
    public let profile: ProfileDomain
}

public struct SetCurrentProfileUseCaseRequest {
    public let profile: ProfileDomain
}

public protocol SetCurrentProfileUseCase {
    func execute(_ request: SetCurrentProfileUseCaseRequest) -> Observable<SetCurrentProfileUseCaseResponse>
}

public final class DefaultSetCurrentProfileUseCase {

    let profileRepository: ProfileRepository
    
    public init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

}

extension DefaultSetCurrentProfileUseCase: SetCurrentProfileUseCase {

    public func execute(_ request: SetCurrentProfileUseCaseRequest) -> Observable<SetCurrentProfileUseCaseResponse> {
        let profile = request.profile
        return self.profileRepository
            .insertProfile(profile, into: .userDefaults)
            .map({ SetCurrentProfileUseCaseResponse(profile: $0) })
    }
    
}
