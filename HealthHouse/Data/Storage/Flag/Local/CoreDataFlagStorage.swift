//
//  CoreDataFlagStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import RxSwift

public protocol CoreDataFlagStorage {
    
    func fetchAllInCoreData() -> Observable<[FlagDomain]>
    
    func insertIntoCoreData(_ flag: FlagDomain) -> Observable<FlagDomain>
    
    func removeInCoreData(_ flag: FlagDomain) -> Observable<FlagDomain>
    
}
