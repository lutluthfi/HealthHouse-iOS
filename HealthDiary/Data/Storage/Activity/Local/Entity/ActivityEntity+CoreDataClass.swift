//
//  ActivityEntity+CoreDataClass.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//
//

import Foundation
import CoreData

@objc(ActivityEntity)
public class ActivityEntity: NSManagedObject {

    public static let entityName = String(describing: ActivityEntity.self)
    
    public convenience init(_ domain: ActivityDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.icon = domain.icon
        self.notes = domain.notes
        self.title = domain.title
    }
    
}

extension ActivityEntity {
    
    @discardableResult
    func createUpdate(with newObject: ActivityDomain, context: NSManagedObjectContext) -> ActivityEntity {
        guard self.objectID == newObject.coreId else {
            return ActivityEntity(newObject, insertInto: context)
        }
        self.updatedAt = Date().toInt64()
        self.icon = newObject.icon
        self.notes = newObject.notes
        self.title = newObject.title
        return self
    }
    
}

extension ActivityEntity {
    
    func toDomain() -> ActivityDomain {
        return ActivityDomain(coreId: self.objectID,
                              createdAt: self.createdAt,
                              updatedAt: self.updatedAt,
                              icon: self.icon,
                              notes: self.notes,
                              title: self.title)
    }
    
}