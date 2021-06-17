//
//  FlagRealm.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 06/06/21.
//

import Foundation
import RealmSwift

@objc final class FlagRealm: Object {
    
    @objc dynamic var ID: FlagID = ""
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    
    @objc dynamic var hexcolor: String = ""
    @objc dynamic var name: String = ""
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    convenience init(ID: FlagID,
                     createdAt: Int64,
                     updatedAt: Int64,
                     hexcolor: String,
                     name: String) {
        self.init()
        self.ID = ID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        self.hexcolor = hexcolor
        self.name = name
    }
    
}

extension FlagRealm {
    
    func toDomain() -> Flag {
        return Flag(realmID: self.ID,
                          createdAt: self.createdAt,
                          updatedAt: self.updatedAt,
                          hexcolor: self.hexcolor,
                          name: self.name)
    }
    
}

extension Flag {
    
    func toRealm() -> FlagRealm {
        return FlagRealm(ID: self.realmID,
                         createdAt: self.createdAt,
                         updatedAt: self.updatedAt,
                         hexcolor: self.hexcolor,
                         name: self.name)
    }
    
}

extension Array where Element == FlagRealm {
    
    func toDomain() -> [Flag] {
        return self.compactMap({ $0.toDomain() })
    }
    
}
