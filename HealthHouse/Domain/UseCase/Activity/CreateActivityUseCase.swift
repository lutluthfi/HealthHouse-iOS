//
//  CreateActivityUseCase.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 27/03/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

public enum CreateActivityUseCaseError {
    
}

extension CreateActivityUseCaseError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct CreateActivityUseCaseResponse {
    
}

public struct CreateActivityUseCaseRequest {
    
    public let doDate: Int64
    public let explanation: String
    public let labels: [LabelDomain]
    public let photoFileNames: [String]
    public let profile: ProfileDomain
    public let title: String
    
}

public protocol CreateActivityUseCase {
    
    func execute(_ request: CreateActivityUseCaseRequest,
                 completion: @escaping (Result<CreateActivityUseCaseResponse, Error>) -> Void)

}

public final class DefaultCreateActivityUseCase {

    public init() {
    }

}

extension DefaultCreateActivityUseCase: CreateActivityUseCase {

    public func execute(_ request: CreateActivityUseCaseRequest,
                        completion: @escaping (Result<CreateActivityUseCaseResponse, Error>) -> Void) {
        
    }
    
}

fileprivate extension ActivityDomain {
    
    static func create(with request: CreateActivityUseCaseRequest) -> ActivityDomain {
        let now = Date().toInt64()
        return ActivityDomain(coreID: nil,
                              createdAt: now,
                              updatedAt: now,
                              doDate: request.doDate,
                              explanation: request.explanation,
                              isArchived: false,
                              isPinned: false,
                              photoFileNames: request.photoFileNames,
                              title: request.title,
                              label: nil,
                              profile: request.profile)
    }
    
}
