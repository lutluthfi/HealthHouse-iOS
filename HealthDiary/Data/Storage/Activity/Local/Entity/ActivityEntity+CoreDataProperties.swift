//
//  ActivityEntity+CoreDataProperties.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//
//

import Foundation
import CoreData


extension ActivityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityEntity> {
        return NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Int64
    
    @NSManaged public var icon: String
    @NSManaged public var notes: String
    @NSManaged public var title: String

}

extension ActivityEntity: Identifiable {

}
