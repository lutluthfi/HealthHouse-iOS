//
//  LabelEntity+CoreDataClass.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData

@objc(LabelEntity)
public class LabelEntity: NSManagedObject {

    public static let entityName = String(describing: LabelEntity.self)
    
    public convenience init(_ domain: LabelDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.hexcolor = domain.hexcolor
        self.name = domain.name
    }
    
}


public extension LabelEntity {
    
    func toDomain() -> LabelDomain {
        return LabelDomain(coreID: self.objectID,
                           createdAt: self.createdAt,
                           updatedAt: self.updatedAt,
                           hexcolor: self.hexcolor,
                           name: self.name)
    }
    
}

public extension LabelEntity {
    
    @discardableResult
    func createUpdate(with newObject: LabelDomain, context: NSManagedObjectContext) -> LabelEntity {
        guard self.objectID == newObject.coreID else {
            return LabelEntity(newObject, insertInto: context)
        }
        self.updatedAt = Date().toInt64()
        
        self.hexcolor = newObject.hexcolor
        self.name = newObject.name
        return self
    }
    
}
