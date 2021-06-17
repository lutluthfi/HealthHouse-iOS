//
//  FetchAllActivityProfileByDoDateUseCaseUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 07/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

enum FetchAllActivityProfileByDoDateUseCaseError: LocalizedError {
    
}

extension FetchAllActivityProfileByDoDateUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct FetchAllActivityProfileByDoDateUseCaseResponse {
    let activities: [Activity]
}

struct FetchAllActivityProfileByDoDateUseCaseRequest {
    let doDate: Int64
    let profile: Profile
}

protocol FetchAllActivityProfileByDoDateUseCase {
    
    func execute(_ request: FetchAllActivityProfileByDoDateUseCaseRequest) -> Single<FetchAllActivityProfileByDoDateUseCaseResponse>

}

final class DefaultFetchAllActivityProfileByDoDateUseCase {

    let activityRepository: ActivityRepository
    
    init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }

}

extension DefaultFetchAllActivityProfileByDoDateUseCase: FetchAllActivityProfileByDoDateUseCase {

    func execute(_ request: FetchAllActivityProfileByDoDateUseCaseRequest) -> Single<FetchAllActivityProfileByDoDateUseCaseResponse> {
        let profile = request.profile
        let doDate = request.doDate
        return self.activityRepository
            .fetchAllActivity(ownedBy: profile, onDoDate: doDate, in: .coreData)
            .map { FetchAllActivityProfileByDoDateUseCaseResponse(activities: $0) }
    }
    
}
