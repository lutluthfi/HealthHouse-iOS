//
//  FlagRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import Foundation
import RxSwift

protocol FlagRepository {
    
    func fetchAllFlag(in storagePoint: StoragePoint) -> Single<[Flag]>
    
    func fetchAllFlag(ownedBy profile: Profile, in storagePoint: StoragePoint) -> Single<[Flag]>
    
    func insertFlag(_ flag: Flag, in storagePoint: StoragePoint) -> Single<Flag>
    
}
