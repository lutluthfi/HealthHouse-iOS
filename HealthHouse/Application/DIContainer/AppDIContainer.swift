//
//  AppDIContainer.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import UIKit

public typealias PresentationFactory = FlowCoordinatorFactory&ControllerFactory
public typealias ControllerFactory =
    ActivityFlowCoordinatorFactory&
    HealthDiaryFlowCoordinatorFactory&
    LaunchFlowCoordinatorFactory&
    ProfileFlowCoordinatorFactory

public final class AppDIContainer {
 
    let navigationController: UINavigationController
    
    lazy var coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared
    
    lazy var localActivityStorage: LocalActivityStorage = DefaultLocalActivityStorage()
    lazy var localProfileStorage: LocalProfileStorage = DefaultLocalProfileStorage()
    lazy var remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage = DefaultRemoteCountryDialingCodeStorage()
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
