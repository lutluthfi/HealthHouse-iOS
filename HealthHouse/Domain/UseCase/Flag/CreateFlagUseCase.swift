//
//  CreateFlagUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum CreateFlagUseCaseError: LocalizedError {
    
}

extension CreateFlagUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct CreateFlagUseCaseResponse {
    public let flag: FlagDomain
}

public struct CreateFlagUseCaseRequest {
    public let coreID: CoreID?
    public let hexcolor: String
    public let name: String
}

public protocol CreateFlagUseCase {
    func execute(_ request: CreateFlagUseCaseRequest) -> Observable<CreateFlagUseCaseResponse>
}

public final class DefaultCreateFlagUseCase {

    let flagRepository: FlagRepository
    
    public init(flagRepository: FlagRepository) {
        self.flagRepository = flagRepository
    }

}

extension DefaultCreateFlagUseCase: CreateFlagUseCase {

    public func execute(_ request: CreateFlagUseCaseRequest) -> Observable<CreateFlagUseCaseResponse> {
        let flag = FlagDomain.make(from: request)
        return self.flagRepository
            .insertFlag(flag, in: .coreData)
            .map({ CreateFlagUseCaseResponse(flag: $0) })
    }
    
}


fileprivate extension FlagDomain {
    
    static func make(from request: CreateFlagUseCaseRequest) -> FlagDomain {
        let now = Date().toInt64()
        return FlagDomain(coreID: request.coreID,
                          createdAt: now,
                          updatedAt: now,
                          hexcolor: request.hexcolor,
                          name: request.name)
    }
    
}
