//
//  CreateUpdateFlagUseCaseUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum CreateUpdateFlagUseCaseError: LocalizedError {
    
}

extension CreateUpdateFlagUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct CreateUpdateFlagUseCaseResponse {
    public let flag: FlagDomain
}

public struct CreateUpdateFlagUseCaseRequest {
    public let coreID: CoreID?
    public let color: UIColor
    public let name: String
}

public protocol CreateUpdateFlagUseCase {
    func execute(_ request: CreateUpdateFlagUseCaseRequest) -> Observable<CreateUpdateFlagUseCaseResponse>
}

public final class DefaultCreateUpdateFlagUseCase {

    let flagRepository: FlagRepository
    
    public init(flagRepository: FlagRepository) {
        self.flagRepository = flagRepository
    }

}

extension DefaultCreateUpdateFlagUseCase: CreateUpdateFlagUseCase {

    public func execute(_ request: CreateUpdateFlagUseCaseRequest) -> Observable<CreateUpdateFlagUseCaseResponse> {
        let flag = FlagDomain.make(from: request)
        return self.flagRepository
            .insertUpdateFlag(flag, in: .coreData)
            .map({ CreateUpdateFlagUseCaseResponse(flag: $0) })
    }
    
}


fileprivate extension FlagDomain {
    
    static func make(from request: CreateUpdateFlagUseCaseRequest) -> FlagDomain {
        let now = Date().toInt64()
        return FlagDomain(coreID: request.coreID,
                          createdAt: now,
                          updatedAt: now,
                          hexcolor: request.color.hexString(),
                          name: request.name)
    }
    
}
