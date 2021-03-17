//
//  ActivityDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation
import CoreData

public struct ActivityDomain {
    
    public let coreId: NSManagedObjectID?
    public let createdAt: Date
    public let updatedAt: Date
    
    public let notes: String
    public let title: String
    
}

extension ActivityDomain: Equatable {
    
    public static func == (lhs: ActivityDomain, rhs: ActivityDomain) -> Bool {
        return lhs.coreId == rhs.coreId
    }
    
}
