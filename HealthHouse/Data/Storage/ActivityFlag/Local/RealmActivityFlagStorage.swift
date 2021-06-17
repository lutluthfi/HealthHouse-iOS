//
//  RealmActivityFlagStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 16/05/21.
//

import Foundation
import RxSwift

protocol RealmActivityFlagStorage {
    
    func fetchAllInRealm() -> Single<[ActivityFlag]>
    
    func fetchAllInRealm(ownedBy profile: Profile) -> Single<[ActivityFlag]>
    
    func fetchInRealm(relatedTo activity: Activity) -> Single<ActivityFlag?>
    
    func insertUpdateIntoRealm(_ activityFlag: ActivityFlag) -> Single<ActivityFlag>
    
    func removeInRealm(relatedTo activity: Activity) -> Single<[ActivityFlag]>
    
}
