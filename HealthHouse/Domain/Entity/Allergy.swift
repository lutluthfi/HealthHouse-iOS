//
//  Allergy.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/07/21.
//

import Foundation
import RxDataSources

typealias AllergyID = String

struct Allergy: EntityDomain {
    
    let realmID: AllergyID
    let createdAt: Int64
    let updatedAt: Int64
    
    let cause: String
    let name: String
    
}

extension Allergy: Equatable {
    
    static func == (lhs: Allergy, rhs: Allergy) -> Bool {
        return
            lhs.realmID == rhs.realmID &&
            lhs.name == rhs.name
    }
    
}

extension Allergy: IdentifiableType {
    
    typealias Identity = String

    var identity: String {
        return self.realmID
    }
    
}
