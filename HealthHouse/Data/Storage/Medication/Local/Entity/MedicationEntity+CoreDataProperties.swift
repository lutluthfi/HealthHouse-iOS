//
//  MedicationEntity+CoreDataProperties.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData


extension MedicationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicationEntity> {
        return NSFetchRequest<MedicationEntity>(entityName: "MedicationEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Int64
    
    @NSManaged public var photoFileNames: [String]
    @NSManaged public var dose: String
    @NSManaged public var endedAt: Int64
    @NSManaged public var location: String
    @NSManaged public var name: String
    @NSManaged public var startedAt: Int64
    
    @NSManaged public var profileID: NSManagedObjectID

}

extension MedicationEntity: Identifiable {
}
