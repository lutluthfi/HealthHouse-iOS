//
//  AppDIContainer.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import UIKit

public typealias PresentationFactory = FlowCoordinatorFactory&ControllerFactory
public typealias ControllerFactory =
    ActivityFlowCoordinatorFactory&
    LocationFlowCoordinatorFactory&
    HealthDiaryFlowCoordinatorFactory&
    FlagFlowCoordinatorFactory&
    LaunchFlowCoordinatorFactory&
    ProfileFlowCoordinatorFactory

public final class AppDIContainer {
 
    let navigationController: UINavigationController
    
    lazy var coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared
    
    lazy var localActivityStorage: LocalActivityStorage = DefaultLocalActivityStorage()
    lazy var localActivityFlagStorage: LocalActivityFlagStorage = DefaultLocalActivityFlagStorage()
    lazy var localFlagStorage: LocalFlagStorage = DefaultLocalFlagStorage()
    lazy var localProfileStorage: LocalProfileStorage = DefaultLocalProfileStorage()
    lazy var remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage = DefaultRemoteCountryDialingCodeStorage()
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
