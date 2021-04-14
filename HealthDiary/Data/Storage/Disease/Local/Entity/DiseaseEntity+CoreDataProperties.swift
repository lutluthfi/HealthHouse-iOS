//
//  DiseaseEntity+CoreDataProperties.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData


extension DiseaseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiseaseEntity> {
        return NSFetchRequest<DiseaseEntity>(entityName: "DiseaseEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Int64
    
    @NSManaged public var doctor: String
    @NSManaged public var photoFileNames: [String]
    @NSManaged public var title: String
    
    @NSManaged public var drugsID: [NSManagedObjectID]

}

extension DiseaseEntity: Identifiable {
}
