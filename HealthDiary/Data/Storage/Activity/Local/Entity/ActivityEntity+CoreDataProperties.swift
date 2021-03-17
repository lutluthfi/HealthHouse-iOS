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

    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var title: String
    @NSManaged public var notes: String

}

extension ActivityEntity: Identifiable {

}
