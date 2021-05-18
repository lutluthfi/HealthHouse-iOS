//
//  EntityDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import CoreData
import Foundation

public protocol EntityDomain {
    
    var coreID: CoreID? { get }
    var createdAt: Int64 { get }
    var updatedAt: Int64 { get }
    
}

public typealias CoreID = NSManagedObjectID

public extension CoreID {
    
    var uriPath: String {
        return self.uriRepresentation().path
    }
    
}

public extension Optional where Wrapped: CoreID {
 
    var uriPathOrEmpty: String {
        return self?.uriRepresentation().path ?? ""
    }
    
}
