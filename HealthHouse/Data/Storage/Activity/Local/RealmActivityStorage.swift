//
//  RealmActivityStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

protocol RealmActivityStorage {
    
    func fetchAllInCoreData() -> Single<[Activity]>
    
    func fetchAllInCoreData(ownedBy profile: Profile) -> Single<[Activity]>
    
    func fetchAllInCoreData(ownedBy profile: Profile, onDoDate doDate: Date) -> Single<[Activity]>
    
    func insertIntoCoreData(_ activity: Activity) -> Single<Activity>
    
    func removeInCoreData(_ activity: Activity) -> Single<Activity>
    
}
