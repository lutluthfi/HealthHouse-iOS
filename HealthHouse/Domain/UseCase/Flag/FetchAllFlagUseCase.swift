//
//  FetchAllFlagUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 20/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

enum FetchAllFlagUseCaseError: LocalizedError {
    
}

extension FetchAllFlagUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct FetchAllFlagUseCaseResponse {
    let flags: [Flag]
}

struct FetchAllFlagUseCaseRequest {
    let profile: Profile
    
    init(ownedBy profile: Profile) {
        self.profile = profile
    }
}

protocol FetchAllFlagUseCase {
    func execute(_ request: FetchAllFlagUseCaseRequest) -> Single<FetchAllFlagUseCaseResponse>
}

final class DefaultFetchAllFlagUseCase {

    let flagRepository: FlagRepository
    
    init(flagRepository: FlagRepository) {
        self.flagRepository = flagRepository
    }

}

extension DefaultFetchAllFlagUseCase: FetchAllFlagUseCase {

    func execute(_ request: FetchAllFlagUseCaseRequest) -> Single<FetchAllFlagUseCaseResponse> {
        let profile = request.profile
        return self.flagRepository
            .fetchAllFlag(ownedBy: profile, in: .coreData)
            .map({ FetchAllFlagUseCaseResponse(flags: $0) })
    }
    
}
