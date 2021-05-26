//
//  FetchAllFlagUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum FetchAllFlagUseCaseError: LocalizedError {
    
}

extension FetchAllFlagUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct FetchAllFlagUseCaseResponse {
    public let flags: [FlagDomain]
}

public struct FetchAllFlagUseCaseRequest {
    public let profile: ProfileDomain
    
    public init(ownedBy profile: ProfileDomain) {
        self.profile = profile
    }
}

public protocol FetchAllFlagUseCase {
    func execute(_ request: FetchAllFlagUseCaseRequest) -> Observable<FetchAllFlagUseCaseResponse>
}

public final class DefaultFetchAllFlagUseCase {

    let flagRepository: FlagRepository
    
    public init(flagRepository: FlagRepository) {
        self.flagRepository = flagRepository
    }

}

extension DefaultFetchAllFlagUseCase: FetchAllFlagUseCase {

    public func execute(_ request: FetchAllFlagUseCaseRequest) -> Observable<FetchAllFlagUseCaseResponse> {
        let profile = request.profile
        return self.flagRepository
            .fetchAllFlag(ownedBy: profile, in: .coreData)
            .map({ FetchAllFlagUseCaseResponse(flags: $0) })
    }
    
}
