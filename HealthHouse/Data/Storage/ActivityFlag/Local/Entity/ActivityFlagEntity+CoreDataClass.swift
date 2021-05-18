//
//  ActivityFlagEntity+CoreDataClass.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//
//

import Foundation
import CoreData

@objc(ActivityFlagEntity)
public class ActivityFlagEntity: NSManagedObject {

    public static let entityName = String(describing: ActivityFlagEntity.self)
    
    public convenience init(_ domain: ActivityFlagDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.activityID = domain.activity.coreID!
        self.flagsID = domain.flags.compactMap({ $0.coreID })
    }
    
}

extension ActivityFlagEntity {
    
    func toDomain(context: NSManagedObjectContext) -> ActivityFlagDomain {
        let activityEntity = context.object(with: self.activityID) as! ActivityEntity
        let labelEntities = self.flagsID.compactMap({ context.object(with: $0) as? FlagEntity })
        let activityDomain = activityEntity.toDomain(context: context)
        let flagDomains = labelEntities.map({ $0.toDomain() })
        return ActivityFlagDomain(coreID: self.objectID,
                                   createdAt: self.createdAt,
                                   updatedAt: self.updatedAt,
                                   activity: activityDomain,
                                   flags: flagDomains)
    }
    
}

extension ActivityFlagEntity {
    
    @discardableResult
    func createUpdate(with newObject: ActivityFlagDomain, context: NSManagedObjectContext) -> ActivityFlagEntity {
        guard self.objectID == newObject.coreID else {
            return ActivityFlagEntity(newObject, insertInto: context)
        }
        self.updatedAt = Date().toInt64()
        
        self.flagsID = newObject.flags.compactMap({ $0.coreID })
        
        return self
    }
    
}
