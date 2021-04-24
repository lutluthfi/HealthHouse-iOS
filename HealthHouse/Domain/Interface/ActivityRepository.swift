//
//  ActivityRepository.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

public protocol ActivityRepository {
    
    func fetchAllActivity(in storagePoint: StoragePoint) -> Observable<[ActivityDomain]>
    
    func fetchAllActivity(ownedBy profile: ProfileDomain,
                          in storagePoint: StoragePoint) -> Observable<[ActivityDomain]>
    
    func insertActivity(_ activity: ActivityDomain,
                        into storagePoint: StoragePoint) -> Observable<ActivityDomain>
    
}
