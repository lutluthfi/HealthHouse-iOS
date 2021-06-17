//
//  ActivityFlag.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import Foundation

typealias ActivityFlagID = String

struct ActivityFlag: EntityDomain {
    
    let realmID: ActivityFlagID
    let createdAt: Int64
    let updatedAt: Int64
    
    let activity: Activity
    let flags: [Flag]
    
}

extension ActivityFlag: Equatable {
    
    static func == (lhs: ActivityFlag, rhs: ActivityFlag) -> Bool {
        return lhs.activity == rhs.activity
    }
    
}
