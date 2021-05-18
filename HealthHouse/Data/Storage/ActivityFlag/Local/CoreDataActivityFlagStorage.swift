//
//  CoreDataActivityFlagStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 16/05/21.
//

import Foundation
import RxSwift

public protocol CoreDataActivityFlagStorage {
    
    func fetchAllInCoreData() -> Observable<[ActivityFlagDomain]>
    
    func fetchAllInCoreData(ownedBy profile: ProfileDomain) -> Observable<[ActivityFlagDomain]>
    
    func fetchInCoreData(relatedTo activity: ActivityDomain) -> Observable<ActivityFlagDomain>
    
    func insertUpdateIntoCoreData(_ activityFlag: ActivityFlagDomain) -> Observable<ActivityFlagDomain>
    
    func removeInCoreData(relatedTo activity: ActivityDomain) -> Observable<ActivityFlagDomain>
    
}
