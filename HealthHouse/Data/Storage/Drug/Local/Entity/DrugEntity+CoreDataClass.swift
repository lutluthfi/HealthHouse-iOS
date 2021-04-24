//
//  DrugEntity+CoreDataClass.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData

@objc(DrugEntity)
public class DrugEntity: NSManagedObject {

    public static let entityName = String(describing: DrugEntity.self)
    
    public convenience init(_ domain: DrugDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.photoFileNames = domain.photoFileNames
        self.dose = domain.dose
        self.endedAt = domain.endedAt
        self.location = domain.location
        self.name = domain.name
        self.startedAt = domain.startedAt
    }
    
}

public extension DrugEntity {
    
    func toDomain() -> DrugDomain {
        return DrugDomain(coreID: self.objectID,
                          createdAt: self.createdAt,
                          updatedAt: self.updatedAt,
                          dose: self.dose,
                          endedAt: self.endedAt,
                          location: self.location,
                          name: self.name,
                          photoFileNames: self.photoFileNames,
                          startedAt: self.startedAt)
    }
    
}

extension DrugEntity {
    
    @discardableResult
    func createUpdate(with newObject: DrugDomain, context: NSManagedObjectContext) -> DrugEntity {
        guard self.objectID == newObject.coreID else {
            return DrugEntity(newObject, insertInto: context)
        }
        self.updatedAt = Date().toInt64()
        self.photoFileNames = newObject.photoFileNames
        self.dose = newObject.dose
        self.endedAt = newObject.endedAt
        self.location = newObject.location
        self.name = newObject.name
        self.startedAt = newObject.startedAt
        return self
    }
    
}
