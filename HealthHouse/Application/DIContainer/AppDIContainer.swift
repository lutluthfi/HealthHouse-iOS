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
        self.realmManager.realm.beginWrite()
        self.realmManager.realm.deleteAll()
        try! self.realmManager.realm.commitWrite()
        self.executeCreateProfileUseCase(dateOfBirth: Int64(867430800).toDate(),
                                         firstName: "Health",
                                         gender: .male,
                                         lastName: "House",
                                         mobileNumber: "+6285216863058",
                                         photo: nil)
            .flatMap(self.executeSetCurrentProfileUseCase(profile:))
            .flatMap({ profile -> Single<Activity> in
                let now = Date()
                let nowInt64 = now.toInt64()
                let doDateInt64 = now.plusDay(Int.random(in: 0...3)).toInt64()
                return self.executeCreateUpdateActivityUseCase(activityID: nil,
                                                               doDate: doDateInt64,
                                                               explanation: "Activity Explanation \(nowInt64)",
                                                               photoFileURLs: [],
                                                               profile: profile,
                                                               title: "Activity Title \(nowInt64)")
            })
            .subscribe()
            .dispose()
        #endif
    }
    
    func executeCreateProfileUseCase(dateOfBirth: Date,
                                     firstName: String,
                                     gender: Gender,
                                     lastName: String,
                                     mobileNumber: String,
                                     photo: UIImage?) -> Single<Profile> {
        let request = CreateProfileUseCaseRequest(dateOfBirth: dateOfBirth,
                                                  firstName: firstName,
                                                  gender: gender,
                                                  lastName: lastName,
                                                  mobileNumber: mobileNumber,
                                                  photo: photo)
        return self.makeCreateProfileUseCase().execute(request).map { $0.profile }
    }
    
    func executeSetCurrentProfileUseCase(profile: Profile) -> Single<Profile> {
        self.makeSetCurrentProfileUseCase()
            .execute(SetCurrentProfileUseCaseRequest(profile: profile))
            .map { $0.profile }
    }
    
    func executeCreateUpdateActivityUseCase(activityID: ActivityID?,
                                            doDate: Int64,
                                            explanation: String,
                                            photoFileURLs: [URL],
                                            profile: Profile,
                                            title: String) -> Single<Activity> {
        let request = CreateUpdateActivityUseCaseRequest(activityID: activityID,
                                                         doDate: doDate,
                                                         explanation: explanation,
                                                         photoFileURLs: photoFileURLs,
                                                         profile: profile,
                                                         title: title)
        return self.makeCreateUpdateActivityUseCase().execute(request).map { $0.activity }
    }
    
}
