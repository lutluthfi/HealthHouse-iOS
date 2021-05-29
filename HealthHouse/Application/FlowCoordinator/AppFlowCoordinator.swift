//
//  AppFlowCoordinator.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//  Copyright (c) 2021 All rights reserved.
//

import RxSwift
import UIKit

// MARK: AppFlowCoordinator
protocol AppFlowCoordinator {
    func start(with instructor: AppFlowCoordinatorInstructor)
}

// MARK: AppFlowCoordinatorInstructor
enum AppFlowCoordinatorInstructor {
    case `default`
}

// MARK: DefaultAppFlowCoordinator
final class DefaultAppFlowCoordinator {

    // MARK: DI Variable
    lazy var disposeBag = DisposeBag()
    let navigationController: UINavigationController
    let flowFactory: FlowCoordinatorFactory
    let localAppConfigStorage: LocalAppConfigStorage
    let fetchCurrentProfileUseCase: FetchCurrentProfileUseCase

    // MARK: Init Funciton
    init(navigationController: UINavigationController,
         presentationFactory: PresentationFactory,
         localAppConfigStorage: LocalAppConfigStorage,
         fetchCurrentProfileUseCase: FetchCurrentProfileUseCase) {
        self.navigationController = navigationController
        self.flowFactory = presentationFactory
        self.localAppConfigStorage = localAppConfigStorage
        self.fetchCurrentProfileUseCase = fetchCurrentProfileUseCase
    }
    
}

extension DefaultAppFlowCoordinator: AppFlowCoordinator {
    
    func start(with instructor: AppFlowCoordinatorInstructor) {
        switch instructor {
        case .default:
//            let request = ATCreateViewModelRequest()
//            let instructor = ActivityFlowCoordinatorInstructor.pushToCreateUI(request)
//            self.flowFactory.makeActivityFlowCoordinator().start(with: instructor)
            
            // The original flow of the app
            self.localAppConfigStorage
                .fetchFirstLaunchFromUserDefaults()
                .do(onSuccess: { [unowned self] (firstLaunch) in
                    if firstLaunch {
                        let request = LNWelcomeViewModelRequest()
                        let instructor = LaunchFlowCoordinatorInstructor.pushToWelcomeUI(request)
                        self.flowFactory.makeLaunchFlowCoordinator().start(with: instructor)
                    } else {
                        let instructor = LaunchFlowCoordinatorInstructor.pushToPadUI
                        self.flowFactory.makeLaunchFlowCoordinator().start(with: instructor)
                    }
                })
                .flatMap(self.localAppConfigStorage.insertFirstLaunchIntoUserDefaults(_:))
                .subscribe()
                .disposed(by: self.disposeBag)
        }
    }
    
}
