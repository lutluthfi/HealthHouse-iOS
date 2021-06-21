//
//  AppDIContainer.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import RealmSwift
import RxSwift
import UIKit

typealias PresentationFactory = FlowCoordinatorFactory&ControllerFactory
typealias ControllerFactory =
    ActivityFlowCoordinatorFactory&
    LocationFlowCoordinatorFactory&
    HealthDiaryFlowCoordinatorFactory&
    FlagFlowCoordinatorFactory&
    LaunchFlowCoordinatorFactory&
    ProfileFlowCoordinatorFactory

final class AppDIContainer {
 
    let navigationController: UINavigationController
    
    var realmConfiguration: Realm.Configuration {
        var configuration = Realm.Configuration.defaultConfiguration
        configuration.schemaVersion = 1
        return configuration
    }
    lazy var realmManager: RealmManagerShared = RealmManager.sharedInstance(config: self.realmConfiguration)
    
    lazy var localActivityStorage: LocalActivityStorage = DefaultLocalActivityStorage()
    lazy var localActivityFlagStorage: LocalActivityFlagStorage = DefaultLocalActivityFlagStorage()
    lazy var localAppConfigStorage: LocalAppConfigStorage = DefaultLocalAppConfigStorage()
    lazy var localFlagStorage: LocalFlagStorage = DefaultLocalFlagStorage()
    lazy var localProfileStorage: LocalProfileStorage = DefaultLocalProfileStorage(realmManager: self.realmManager)
    lazy var remoteCountryDialingCodeStorage: RemoteCountryDialingCodeStorage = DefaultRemoteCountryDialingCodeStorage()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        #if DEV && DEBUG
        let request = CreateProfileUseCaseRequest(dateOfBirth: Int64(867430800).toDate(),
                                                  firstName: "Health",
                                                  gender: .male,
                                                  lastName: "House",
                                                  mobileNumber: "+6285216863058",
                                                  photo: nil)
        self.makeCreateProfileUseCase()
            .execute(request)
            .map { $0.profile }
            .flatMap(self.executeSetCurrentProfileUseCase(profile:))
            .subscribe()
            .dispose()
        #endif
    }
    
    func executeSetCurrentProfileUseCase(profile: Profile) -> Single<Profile> {
        self.makeSetCurrentProfileUseCase()
            .execute(SetCurrentProfileUseCaseRequest(profile: profile))
            .map { $0.profile }
    }
    
}
