//
//  FlagEntity+CoreDataClass.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData

@objc(FlagEntity)
public class FlagEntity: NSManagedObject {

    public static let entityName = String(describing: FlagEntity.self)
    
    public convenience init(_ domain: FlagDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.hexcolor = domain.hexcolor
        self.name = domain.name
    }
    
}


public extension FlagEntity {
    
    func toDomain() -> FlagDomain {
        return FlagDomain(coreID: self.objectID,
                           createdAt: self.createdAt,
                           updatedAt: self.updatedAt,
                           hexcolor: self.hexcolor,
                           name: self.name)
    }
    
}

public extension FlagEntity {
    
    @discardableResult
    func createUpdate(with newObject: FlagDomain, context: NSManagedObjectContext) -> FlagEntity {
        guard self.objectID == newObject.coreID else {
            return FlagEntity(newObject, insertInto: context)
        }
        self.updatedAt = Date().toInt64()
        
        self.hexcolor = newObject.hexcolor
        self.name = newObject.name
        return self
    }
    
}
