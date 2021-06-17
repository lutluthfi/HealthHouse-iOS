//
//  ActivityRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 27/03/21.
//

import Foundation
import RxSwift

protocol ActivityRepository {
    
    func fetchAllActivity(in storagePoint: StoragePoint) -> Single<[Activity]>
    
    func fetchAllActivity(ownedBy profile: Profile,
                          in storagePoint: StoragePoint) -> Single<[Activity]>
    
    func fetchAllActivity(ownedBy profile: Profile,
                          onDoDate doDate: Int64,
                          in storagePoint: StoragePoint) -> Single<[Activity]>
    
    func insertUpdateActivity(_ activity: Activity,
                              into storagePoint: StoragePoint) -> Single<Activity>
    
}
