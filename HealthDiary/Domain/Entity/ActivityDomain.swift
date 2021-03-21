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
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let icon: String
    public let notes: String
    public let title: String
    
    public init(coreId: NSManagedObjectID? = nil,
                createdAt: Int64,
                updatedAt: Int64,
                icon: String,
                notes: String,
                title: String) {
        self.coreId = coreId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.icon = icon
        self.notes = notes
        self.title = title
    }
    
}

extension ActivityDomain: Equatable {
    
    public static func == (lhs: ActivityDomain, rhs: ActivityDomain) -> Bool {
        return lhs.coreId == rhs.coreId
    }
    
}
