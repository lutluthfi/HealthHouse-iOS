//
//  CreateFlagUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

enum CreateFlagUseCaseError: LocalizedError {
    
}

extension CreateFlagUseCaseError {
    
    var errorDescription: String? {
        switch self {
        }
    }
    
}

struct CreateFlagUseCaseResponse {
    
    let flag: Flag
    
}

struct CreateFlagUseCaseRequest {
    
    let realmID: FlagID?
    let hexcolor: String
    let name: String
    
}

protocol CreateFlagUseCase {
    
    func execute(_ request: CreateFlagUseCaseRequest) -> Single<CreateFlagUseCaseResponse>
    
}

final class DefaultCreateFlagUseCase {
    
    let flagRepository: FlagRepository
    
    init(flagRepository: FlagRepository) {
        self.flagRepository = flagRepository
    }
    
}

extension DefaultCreateFlagUseCase: CreateFlagUseCase {
    
    func execute(_ request: CreateFlagUseCaseRequest) -> Single<CreateFlagUseCaseResponse> {
        let flag = Flag.make(from: request)
        return self.flagRepository
            .insertFlag(flag, in: .realm)
            .map({ CreateFlagUseCaseResponse(flag: $0) })
    }
    
}


fileprivate extension Flag {
    
    static func make(from request: CreateFlagUseCaseRequest) -> Flag {
        let now = Date().toInt64()
        return Flag(realmID: request.realmID.orMakePrimaryKey,
                    createdAt: now,
                    updatedAt: now,
                    hexcolor: request.hexcolor,
                    name: request.name)
    }
    
}
