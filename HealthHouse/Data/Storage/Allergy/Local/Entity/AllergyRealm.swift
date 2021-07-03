//
//  AllergyRealm.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/07/21.
//

import Foundation
import RealmSwift

@objc final class AllergyRealm: Object {
    
    @objc dynamic var ID: AllergyID = ""
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    
    @objc dynamic var cause: String = ""
    @objc dynamic var effect: String = ""
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    convenience init(ID: AllergyID,
                     createdAt: Int64,
                     updatedAt: Int64,
                     cause: String,
                     effect: String) {
        self.init()
        self.ID = ID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        self.cause = cause
        self.effect = effect
    }
    
}

extension AllergyRealm {
    
    func toDomain() -> Allergy {
        return Allergy(realmID: self.ID,
                       createdAt: self.createdAt,
                       updatedAt: self.updatedAt,
                       cause: self.cause,
                       effect: self.effect)
    }
    
}

extension Array where Element == AllergyRealm {
    
    func toDomain() -> [Allergy] {
        return self.map { $0.toDomain() }
    }
    
}

extension Allergy {
    
    func toRealm() -> AllergyRealm {
        return AllergyRealm(ID: self.realmID,
                            createdAt: self.createdAt,
                            updatedAt: self.updatedAt,
                            cause: self.cause,
                            effect: self.effect)
    }
    
}

extension Array where Element == Allergy {
    
    func toRealm() -> [AllergyRealm] {
        return self.map { $0.toRealm() }
    }
    
}
