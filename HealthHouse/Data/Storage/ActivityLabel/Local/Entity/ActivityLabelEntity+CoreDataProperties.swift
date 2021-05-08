//
//  ActivityLabelEntity+CoreDataProperties.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//
//

import Foundation
import CoreData


extension ActivityLabelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityLabelEntity> {
        return NSFetchRequest<ActivityLabelEntity>(entityName: "ActivityLabelEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Int64
    
    @NSManaged public var activityID: NSManagedObjectID
    @NSManaged public var labelsID: [NSManagedObjectID]

}

extension ActivityLabelEntity : Identifiable {

}
