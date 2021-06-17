//
//  CreateUpdateActivityUseCaseUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 07/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

enum CreateUpdateActivityUseCaseError: LocalizedError {
    
}

extension CreateUpdateActivityUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct CreateUpdateActivityUseCaseResponse {
    let activity: Activity
}

struct CreateUpdateActivityUseCaseRequest {
    let activityID: ActivityID?
    let doDate: Int64
    let explanation: String
    let photoFileURLs: [URL]
    let profile: Profile
    let title: String
}

protocol CreateUpdateActivityUseCase {
    
    func execute(_ request: CreateUpdateActivityUseCaseRequest) -> Single<CreateUpdateActivityUseCaseResponse>
    
}

final class DefaultCreateUpdateActivityUseCase {
    
    let activityRepository: ActivityRepository
    
    init(activityRepository: ActivityRepository) {
        self.activityRepository = activityRepository
    }
    
}

extension DefaultCreateUpdateActivityUseCase: CreateUpdateActivityUseCase {
    
    func execute(_ request: CreateUpdateActivityUseCaseRequest) -> Single<CreateUpdateActivityUseCaseResponse> {
        let activity = Activity.make(from: request)
        return self.activityRepository
            .insertUpdateActivity(activity, into: .coreData)
            .map { CreateUpdateActivityUseCaseResponse(activity: $0) }
    }
    
}

private extension Activity {
    
    static func make(from request: CreateUpdateActivityUseCaseRequest) -> Activity {
        let now = Date().toInt64()
        let photoFilesNames = request.photoFileURLs.map { $0.lastPathComponent }
        return Activity(realmID: request.activityID.orMakePrimaryKey,
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
