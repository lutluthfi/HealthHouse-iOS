//
//  FetchCurrentProfileUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 21/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum FetchCurrentProfileUseCaseError: LocalizedError {
    
}

extension FetchCurrentProfileUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct FetchCurrentProfileUseCaseResponse {
    public let profile: ProfileDomain?
}

public struct FetchCurrentProfileUseCaseRequest {

}

public protocol FetchCurrentProfileUseCase {
    func execute(_ request: FetchCurrentProfileUseCaseRequest) -> Observable<FetchCurrentProfileUseCaseResponse>
}

public final class DefaultFetchCurrentProfileUseCase {

    let profileRepository: ProfileRepository
    
    public init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }

}

extension DefaultFetchCurrentProfileUseCase: FetchCurrentProfileUseCase {

    public func execute(_ request: FetchCurrentProfileUseCaseRequest) -> Observable<FetchCurrentProfileUseCaseResponse> {
        return self.profileRepository
            .fetchProfile(in: .userDefaults)
            .map({ FetchCurrentProfileUseCaseResponse(profile: $0) })
    }
    
}
