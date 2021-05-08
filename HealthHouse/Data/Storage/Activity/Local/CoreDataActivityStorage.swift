//
//  CoreDataActivityStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

public protocol CoreDataActivityStorage {
    
    func fetchAllInCoreData() -> Observable<[ActivityDomain]>
    
    func fetchAllInCoreData(ownedBy profile: ProfileDomain) -> Observable<[ActivityDomain]>
    
    func fetchAllInCoreData(ownedBy profile: ProfileDomain, onDoDate doDate: Int64) -> Observable<[ActivityDomain]>
    
    func insertIntoCoreData(_ activity: ActivityDomain) -> Observable<ActivityDomain>
    
    func removeInCoreData(_ activity: ActivityDomain) -> Observable<ActivityDomain>
    
}
