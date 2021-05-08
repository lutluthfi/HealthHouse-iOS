//
//  ActivityEntity+CoreDataProperties.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
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
    
    @NSManaged public var doDate: Int64
    @NSManaged public var explanation: String
    @NSManaged public var isArchived: Bool
    @NSManaged public var isPinned: Bool
    @NSManaged public var photoFileNames: [String]
    @NSManaged public var title: String
    
    @NSManaged public var profileID: NSManagedObjectID

}

extension ActivityEntity: Identifiable {
}
