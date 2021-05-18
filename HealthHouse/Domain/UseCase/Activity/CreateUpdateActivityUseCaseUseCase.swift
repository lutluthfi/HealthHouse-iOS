//
//  CreateUpdateActivityUseCaseUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 07/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum CreateUpdateActivityUseCaseError: LocalizedError {
    
}

extension CreateUpdateActivityUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct CreateUpdateActivityUseCaseResponse {
    public let activity: ActivityDomain
}

public struct CreateUpdateActivityUseCaseRequest {
    public let coreID: CoreID?
    public let doDate: Int64
    public let explanation: String
    public let photoFileURLs: [URL]
    public let profile: ProfileDomain
    public let title: String
}

public protocol CreateUpdateActivityUseCase {
    
    func execute(_ request: CreateUpdateActivityUseCaseRequest) -> Observable<CreateUpdateActivityUseCaseResponse>

}

public final class DefaultCreateUpdateActivityUseCase {

    let activityRepository: ActivityRepository
    
    public init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }

}

extension DefaultCreateUpdateActivityUseCase: CreateUpdateActivityUseCase {

    public func execute(_ request: CreateUpdateActivityUseCaseRequest) -> Observable<CreateUpdateActivityUseCaseResponse> {
        let activity = ActivityDomain.make(from: request)
        return self.activityRepository
            .insertUpdateActivity(activity, into: .coreData)
            .map { CreateUpdateActivityUseCaseResponse(activity: $0) }
    }
    
}

private extension ActivityDomain {
    
    static func make(from request: CreateUpdateActivityUseCaseRequest) -> ActivityDomain {
        let now = Date().toInt64()
        let photoFilesNames = request.photoFileURLs.map { $0.lastPathComponent }
        return ActivityDomain(coreID: request.coreID,
                              createdAt: now,
                              updatedAt: now,
                              doDate: request.doDate,
                              explanation: request.explanation,
                              isArchived: false,
                              isPinned: false,
                              photoFileNames: photoFilesNames,
                              title: request.title,
                              profile: request.profile)
    }
    
}
