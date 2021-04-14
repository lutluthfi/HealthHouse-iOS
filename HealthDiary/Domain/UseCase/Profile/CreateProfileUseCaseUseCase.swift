//
//  CreateProfileUseCaseUseCase.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 11/04/21.
//  Copyright (c) 2021 All rights reserved.

import Foundation

public enum CreateProfileUseCaseUseCaseError: LocalizedError {
    
}

extension CreateProfileUseCaseUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct CreateProfileUseCaseUseCaseResponse {
    
}

public struct CreateProfileUseCaseUseCaseRequest {

}

public protocol CreateProfileUseCaseUseCase {
    
    func execute(_ request: CreateProfileUseCaseUseCaseRequest,
                 completion: @escaping (Result<CreateProfileUseCaseUseCaseResponse, Error>) -> Void)

}

public final class DefaultCreateProfileUseCaseUseCase {

    public init() {
    }

}

extension DefaultCreateProfileUseCaseUseCase: CreateProfileUseCaseUseCase {

    public func execute(_ request: CreateProfileUseCaseUseCaseRequest,
                        completion: @escaping (Result<CreateProfileUseCaseUseCaseResponse, Error>) -> Void) {
        
    }
    
}
