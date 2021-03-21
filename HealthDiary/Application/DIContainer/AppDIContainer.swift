//
//  AppDIContainer.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import UIKit

public typealias PresentationFactory = FlowCoordinatorFactory&ControllerFactory
public typealias ControllerFactory = LaunchFlowCoordinatorFactory

public final class AppDIContainer {
 
    let navigationController: UINavigationController
    
    lazy var coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
