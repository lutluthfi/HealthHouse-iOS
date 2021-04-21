//
//  FetchAllActivityUseCase.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 20/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation
import RxSwift

public enum FetchAllActivityUseCaseError: LocalizedError {
    
}

extension FetchAllActivityUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct FetchAllActivityUseCaseResponse {
    
    public let activities: [ActivityDomain]
    
}

public struct FetchAllActivityUseCaseRequest {

    public let profile: ProfileDomain
    
}

public protocol FetchAllActivityUseCase {
    
    func execute(_ request: FetchAllActivityUseCaseRequest) -> Observable<FetchAllActivityUseCaseResponse>

}

public final class DefaultFetchAllActivityUseCase {

    let activityRepository: ActivityRepository
    
    public init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }

}

extension DefaultFetchAllActivityUseCase: FetchAllActivityUseCase {

    public func execute(_ request: FetchAllActivityUseCaseRequest) -> Observable<FetchAllActivityUseCaseResponse> {
        return self.activityRepository
            .fetchAllActivity(ownedBy: request.profile, in: .coreData)
            .map { FetchAllActivityUseCaseResponse(activities: $0) }
    }
    
}
