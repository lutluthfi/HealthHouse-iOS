//
//  AllergyRepository.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/07/21.
//

import Foundation
import RxSwift

protocol AllergyRepository {
    
    func fetchAllAllergy(ownedBy profile: Profile,
                         in storagePoint: StoragePoint) -> Single<[Allergy]>
    
    func insertUpdateAllergy(_ allergy: Allergy,
                             ownedBy profile: Profile,
                             into storagePoint: StoragePoint) -> Single<Allergy>
    
    func removeAllergy(_ allergy: Allergy,
                       ownedBy profile: Profile,
                       in storagePoint: StoragePoint) -> Single<Allergy>
    
}
