//
//  FlagEntity+CoreDataProperties.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData


extension FlagEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlagEntity> {
        return NSFetchRequest<FlagEntity>(entityName: "FlagEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Int64
    
    @NSManaged public var hexcolor: String
    @NSManaged public var name: String

}

extension FlagEntity: Identifiable {
}
