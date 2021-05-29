//
//  UpdateAppConfigFirstLaunchUseCase.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 30/05/21.
//  Copyright (c) 2021 All rights reserved.
//

import Foundation
import RxSwift

public enum UpdateAppConfigFirstLaunchUseCaseError: LocalizedError {
    
}

extension UpdateAppConfigFirstLaunchUseCaseError {
    
    public var errorDescription: String? {
        switch self {
        }
    }
    
}

public struct UpdateAppConfigFirstLaunchUseCaseResponse {
    public let firstLaunch: Bool
}

public struct UpdateAppConfigFirstLaunchUseCaseRequest {
    public let firstLaunch: Bool
}

public protocol UpdateAppConfigFirstLaunchUseCase {
    func execute(_ request: UpdateAppConfigFirstLaunchUseCaseRequest) -> Single<UpdateAppConfigFirstLaunchUseCaseResponse>
}

public final class DefaultUpdateAppConfigFirstLaunchUseCase {

    let appConfigRepository: AppConfigRepository
    
    public init(appConfigRepository: AppConfigRepository) {
        self.appConfigRepository = appConfigRepository
    }

}

extension DefaultUpdateAppConfigFirstLaunchUseCase: UpdateAppConfigFirstLaunchUseCase {

    public func execute(_ request: UpdateAppConfigFirstLaunchUseCaseRequest) -> Single<UpdateAppConfigFirstLaunchUseCaseResponse> {
        let firstLaunch = request.firstLaunch
        return self.appConfigRepository
            .insertFirstLaunch(firstLaunch, in: .userDefaults)
            .map({ UpdateAppConfigFirstLaunchUseCaseResponse(firstLaunch: $0) })
    }
    
}
