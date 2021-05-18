//
//  ActivityFlagDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import Foundation

public struct ActivityFlagDomain: EntityDomain {
    
    public let coreID: CoreID?
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let activity: ActivityDomain
    public let flags: [FlagDomain]
    
}

extension ActivityFlagDomain: Equatable {
    
    public static func == (lhs: ActivityFlagDomain, rhs: ActivityFlagDomain) -> Bool {
        return lhs.activity == rhs.activity
    }
    
}
