//
//  FetchAllActivityByProfileUseCaseUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 07/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

enum FetchAllActivityByProfileUseCaseError: LocalizedError {
    
}

extension FetchAllActivityByProfileUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct FetchAllActivityByProfileUseCaseResponse {
    let activities: [Activity]
}

struct FetchAllActivityByProfileUseCaseRequest {
    let profile: Profile
}

protocol FetchAllActivityByProfileUseCase {
    
    func execute(_ request: FetchAllActivityByProfileUseCaseRequest) -> Single<FetchAllActivityByProfileUseCaseResponse>

}

final class DefaultFetchAllActivityByProfileUseCase {

    let activityRepository: ActivityRepository
    
    init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }

}

extension DefaultFetchAllActivityByProfileUseCase: FetchAllActivityByProfileUseCase {

    func execute(_ request: FetchAllActivityByProfileUseCaseRequest) -> Single<FetchAllActivityByProfileUseCaseResponse> {
        let profile = request.profile
        return self.activityRepository
            .fetchAllActivity(ownedBy: profile, in: .coreData)
            .map { FetchAllActivityByProfileUseCaseResponse(activities: $0) }
    }
    
}
