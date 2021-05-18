//
//  ActivityFlagEntity+CoreDataProperties.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//
//

import Foundation
import CoreData


extension ActivityFlagEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityFlagEntity> {
        return NSFetchRequest<ActivityFlagEntity>(entityName: "ActivityFlagEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Int64
    
    @NSManaged public var activityID: NSManagedObjectID
    @NSManaged public var flagsID: [NSManagedObjectID]

}

extension ActivityFlagEntity : Identifiable {

}
