//
//  RealmProfileStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation
import RxSwift

protocol RealmProfileStorage {
    
    func fetchAllInRealm() -> Single<[Profile]>
    
    func insertIntoRealm(_ profile: Profile) -> Single<Profile>
    
    func removeInRealm(_ profile: Profile) -> Single<Profile>
    
}
