//
//  RealmFlagStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import RxSwift

protocol RealmFlagStorage {
    
    func fetchAllInCoreData() -> Single<[Flag]>
    
    func insertIntoCoreData(_ flag: Flag) -> Single<Flag>
    
    func removeInCoreData(_ flag: Flag) -> Single<Flag>
    
}
