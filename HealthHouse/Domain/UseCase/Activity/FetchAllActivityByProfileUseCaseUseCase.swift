//
//  FetchAllActivityByProfileUseCaseUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 07/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum FetchAllActivityByProfileUseCaseError: LocalizedError {
    
}

extension FetchAllActivityByProfileUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct FetchAllActivityByProfileUseCaseResponse {
    public let activities: [ActivityDomain]
}

public struct FetchAllActivityByProfileUseCaseRequest {
    public let profile: ProfileDomain
}

public protocol FetchAllActivityByProfileUseCase {
    
    func execute(_ request: FetchAllActivityByProfileUseCaseRequest) -> Observable<FetchAllActivityByProfileUseCaseResponse>

}

public final class DefaultFetchAllActivityByProfileUseCase {

    let activityRepository: ActivityRepository
    
    public init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }

}

extension DefaultFetchAllActivityByProfileUseCase: FetchAllActivityByProfileUseCase {

    public func execute(_ request: FetchAllActivityByProfileUseCaseRequest) -> Observable<FetchAllActivityByProfileUseCaseResponse> {
        let profile = request.profile
        return self.activityRepository
            .fetchAllActivity(ownedBy: profile, in: .coreData)
            .map { FetchAllActivityByProfileUseCaseResponse(activities: $0) }
    }
    
}
