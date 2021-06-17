//
//  FetchCurrentProfileUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 21/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

enum FetchCurrentProfileUseCaseError: LocalizedError {
    
}

extension FetchCurrentProfileUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

struct FetchCurrentProfileUseCaseResponse {
    public let profile: Profile?
}

struct FetchCurrentProfileUseCaseRequest {

}

protocol FetchCurrentProfileUseCase {
    func execute(_ request: FetchCurrentProfileUseCaseRequest) -> Single<FetchCurrentProfileUseCaseResponse>
}

final class DefaultFetchCurrentProfileUseCase {

    let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

}

extension DefaultFetchCurrentProfileUseCase: FetchCurrentProfileUseCase {

    func execute(_ request: FetchCurrentProfileUseCaseRequest) -> Single<FetchCurrentProfileUseCaseResponse> {
        return self.profileRepository
            .fetchProfile(in: .userDefaults)
            .map({ FetchCurrentProfileUseCaseResponse(profile: $0) })
    }
    
}
