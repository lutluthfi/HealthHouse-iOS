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
        self.title = domain.title
        self.notes = domain.notes
    }
    
}

extension ActivityEntity {
    
    func toDomain() -> ActivityDomain {
        return ActivityDomain(coreId: self.objectID,
                              createdAt: self.createdAt,
                              updatedAt: self.updatedAt,
                              notes: self.notes,
                              title: self.title)
    }
    
}
