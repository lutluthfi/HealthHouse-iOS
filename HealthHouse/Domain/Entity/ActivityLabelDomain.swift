//
//  ActivityLabelDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import Foundation

public struct ActivityLabelDomain: EntityDomain {
    
    public let coreID: CoreID?
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let activity: ActivityDomain
    public let labels: [LabelDomain]
    
}
