//
//  FlagRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 18/05/21.
//

import Foundation
import RxSwift

public protocol FlagRepository {
    
    func fetchAllFlag(in storagePoint: StoragePoint) -> Observable<[FlagDomain]>
    
    func fetchAllFlag(ownedBy profile: ProfileDomain, in storagePoint: StoragePoint) -> Observable<[FlagDomain]>
    
    func insertFlag(_ flag: FlagDomain, in storagePoint: StoragePoint) -> Observable<FlagDomain>
    
}
