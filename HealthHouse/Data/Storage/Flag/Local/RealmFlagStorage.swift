//
//  RealmFlagStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import RxSwift

protocol RealmFlagStorage {
    
    func fetchAllInRealm() -> Single<[Flag]>
    
    func insertIntoRealm(_ flag: Flag) -> Single<Flag>
    
    func removeInRealm(_ flag: Flag) -> Single<Flag>
    
}
