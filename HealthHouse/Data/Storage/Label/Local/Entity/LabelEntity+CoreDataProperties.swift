//
//  LabelEntity+CoreDataProperties.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData


extension LabelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LabelEntity> {
        return NSFetchRequest<LabelEntity>(entityName: "LabelEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Int64
    
    @NSManaged public var hexcolor: String
    @NSManaged public var name: String

}

extension LabelEntity: Identifiable {
}
