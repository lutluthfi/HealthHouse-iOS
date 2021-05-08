//
//  EntityDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import CoreData
import Foundation

public typealias CoreID = NSManagedObjectID

public protocol EntityDomain {
    
    var coreID: CoreID? { get }
    var createdAt: Int64 { get }
    var updatedAt: Int64 { get }
    
}
