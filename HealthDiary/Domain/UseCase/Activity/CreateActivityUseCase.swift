//
//  CreateActivityUseCase.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 27/03/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

public enum CreateActivityUseCaseError: LocalizedError {
    
}

extension CreateActivityUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct CreateActivityUseCaseResponse {
    
}

public struct CreateActivityUseCaseRequest {

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
