//
//  LabelDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

public struct LabelDomain: EntityDomain {
    
    public let coreID: CoreID?
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let name: String
    
}

extension LabelDomain: Equatable {
    
    public static func == (lhs: LabelDomain, rhs: LabelDomain) -> Bool {
        return lhs.coreID == rhs.coreID && lhs.name == lhs.name
    }
    
}
