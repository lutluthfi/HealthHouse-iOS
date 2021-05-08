//
//  FetchAllActivityProfileByDoDateUseCaseUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 07/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum FetchAllActivityProfileByDoDateUseCaseError: LocalizedError {
    
}

extension FetchAllActivityProfileByDoDateUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct FetchAllActivityProfileByDoDateUseCaseResponse {
    public let activities: [ActivityDomain]
}

public struct FetchAllActivityProfileByDoDateUseCaseRequest {
    public let doDate: Int64
    public let profile: ProfileDomain
}

public protocol FetchAllActivityProfileByDoDateUseCase {
    
    func execute(_ request: FetchAllActivityProfileByDoDateUseCaseRequest) -> Observable<FetchAllActivityProfileByDoDateUseCaseResponse>

}

public final class DefaultFetchAllActivityProfileByDoDateUseCase {

    let activityRepository: ActivityRepository
    
    public init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }

}

extension DefaultFetchAllActivityProfileByDoDateUseCase: FetchAllActivityProfileByDoDateUseCase {

    public func execute(_ request: FetchAllActivityProfileByDoDateUseCaseRequest) -> Observable<FetchAllActivityProfileByDoDateUseCaseResponse> {
        let profile = request.profile
        let doDate = request.doDate
        return self.activityRepository
            .fetchAllActivity(ownedBy: profile, onDoDate: doDate, in: .coreData)
            .map { FetchAllActivityProfileByDoDateUseCaseResponse(activities: $0) }
    }
    
}
