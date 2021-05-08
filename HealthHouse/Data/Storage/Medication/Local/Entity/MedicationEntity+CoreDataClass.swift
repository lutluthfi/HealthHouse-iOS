//
//  MedicationEntity+CoreDataClass.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData

@objc(MedicationEntity)
public class MedicationEntity: NSManagedObject {
    
    public static let entityName = String(describing: MedicationEntity.self)
    
    public convenience init(_ domain: MedicationDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.photoFileNames = domain.photoFileNames
        self.dose = domain.dose
        self.endedAt = domain.endedAt
        self.location = domain.location
        self.name = domain.name
        self.startedAt = domain.startedAt
        
        self.profileID = domain.profile.coreID!
    }
    
}

public extension MedicationEntity {
    
    func toDomain(context: NSManagedObjectContext) -> MedicationDomain {
        let profile = context.object(with: self.profileID) as! ProfileEntity
        return MedicationDomain(coreID: self.objectID,
                                createdAt: self.createdAt,
                                updatedAt: self.updatedAt,
                                dose: self.dose,
                                endedAt: self.endedAt,
                                location: self.location,
                                name: self.name,
                                photoFileNames: self.photoFileNames,
                                startedAt: self.startedAt,
                                profile: profile.toDomain())
    }
    
}

extension MedicationEntity {
    
    @discardableResult
    func createUpdate(with newObject: MedicationDomain, context: NSManagedObjectContext) -> MedicationEntity {
        guard self.objectID == newObject.coreID else {
            return MedicationEntity(newObject, insertInto: context)
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
