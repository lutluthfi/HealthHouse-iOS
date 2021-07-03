//
//  RealmActivityStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

protocol RealmActivityStorage {
    
    func fetchAllInRealm() -> Single<[Activity]>
    
    func fetchAllInRealm(ownedBy profile: Profile) -> Single<[Activity]>
    
    func fetchAllInRealm(ownedBy profile: Profile, onDoDate doDate: Date) -> Single<[Activity]>
    
    func insertIntoRealm(_ activity: Activity) -> Single<Activity>
    
    func removeInRealm(_ activity: Activity) -> Single<Activity>
    
}
