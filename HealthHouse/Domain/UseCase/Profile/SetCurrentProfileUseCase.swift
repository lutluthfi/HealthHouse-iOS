//
//  SetCurrentProfileUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 26/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

enum SetCurrentProfileUseCaseError: LocalizedError {
    
}

extension SetCurrentProfileUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct SetCurrentProfileUseCaseResponse {
    let profile: Profile
}

struct SetCurrentProfileUseCaseRequest {
    let profile: Profile
}

protocol SetCurrentProfileUseCase {
    func execute(_ request: SetCurrentProfileUseCaseRequest) -> Single<SetCurrentProfileUseCaseResponse>
}

final class DefaultSetCurrentProfileUseCase {

    let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

}

extension DefaultSetCurrentProfileUseCase: SetCurrentProfileUseCase {

    func execute(_ request: SetCurrentProfileUseCaseRequest) -> Single<SetCurrentProfileUseCaseResponse> {
        let profile = request.profile
        return self.profileRepository
            .insertProfile(profile, into: .userDefaults)
            .map({ SetCurrentProfileUseCaseResponse(profile: $0) })
    }
    
}
