//
//  ActivityFlagRealm.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 06/06/21.
//

import Foundation
import RealmSwift

@objc final class ActivityFlagRealm: Object {
    
    @objc dynamic var ID: ActivityFlagID = ""
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    
    @objc dynamic var activityID: ActivityID = ""
    var flagsIDs = List<FlagID>()
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    convenience init(ID: ActivityFlagID,
                     createdAt: Int64,
                     updatedAt: Int64,
                     activityID: ActivityID,
                     flagsIDs: [FlagID]) {
        self.init()
        self.ID = ID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        self.activityID = activityID
        self.flagsIDs = flagsIDs.asRealmList
    }
    
}

extension ActivityFlagRealm {
    
    func toDomain() -> ActivityFlag {
        let activityRealm = self.realm?.object(ofType: ActivityRealm.self, forPrimaryKey: self.activityID)
        let activityDomain = activityRealm!.toDomain()
        let flagRealms = self.flagsIDs.compactMap({
            self.realm?.object(ofType: FlagRealm.self, forPrimaryKey: $0)
        })
        let flagDomains = Array(flagRealms).toDomain()
        return ActivityFlag(realmID: self.ID,
                            createdAt: self.createdAt,
                            updatedAt: self.updatedAt,
                            activity: activityDomain,
                            flags: flagDomains)
    }
    
}

extension ActivityFlag {
    
    func toRealm() -> ActivityFlagRealm {
        return ActivityFlagRealm(ID: self.realmID,
                                 createdAt: self.createdAt,
                                 updatedAt: self.updatedAt,
                                 activityID: self.activity.realmID,
                                 flagsIDs: self.flags.map { $0.realmID })
    }
    
}

extension Array where Element == ActivityFlagRealm {
    
    func toDomain() -> [ActivityFlag] {
        return self.compactMap({ $0.toDomain() })
    }
    
}
