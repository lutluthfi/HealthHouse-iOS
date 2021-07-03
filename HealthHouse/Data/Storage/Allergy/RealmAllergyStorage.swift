//
//  RealmAllergyStorage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/07/21.
//

import Foundation
import RxSwift

protocol RealmAllergyStorage {
    
    func fetchAllInRealm() -> Single<[Allergy]>
    
    func fetchAllInRealm(ownedBy profile: Profile) -> Single<[Allergy]>
    
    func insertIntoRealm(_ allergy: Allergy) -> Single<Allergy>
    
    func removeInRealm(_ allergy: Allergy) -> Single<Allergy>
    
}
