//
//  DiseaseEntity+CoreDataClass.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData

@objc(DiseaseEntity)
public class DiseaseEntity: NSManagedObject {

    public static let entityName = String(describing: DiseaseEntity.self)
    
    public convenience init(_ domain: DiseaseDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        self.doctor = domain.doctor
        self.photoFileNames = domain.photoFileNames
        self.title = domain.title
        self.drugsID = domain.drugs.compactMap { $0.coreID }
    }
    
}

public extension DiseaseEntity {
    
    func toDomain(context: NSManagedObjectContext) -> DiseaseDomain {
        let drugs = self.drugsID
            .compactMap { context.object(with: $0) as? DrugEntity }
            .map { $0.toDomain() }
        return DiseaseDomain(coreID: self.objectID,
                             createdAt: self.createdAt,
                             updatedAt: self.updatedAt,
                             doctor: self.doctor,
                             photoFileNames: self.photoFileNames,
                             title: self.title,
                             drugs: drugs)
    }
    
}

public extension DiseaseEntity {
    
    @discardableResult
    func createUpdate(with newObject: DiseaseDomain, context: NSManagedObjectContext) -> DiseaseEntity {
        guard self.objectID == newObject.coreID else {
            return DiseaseEntity(newObject, insertInto: context)
        }
        self.updatedAt = Date().toInt64()
        self.doctor = newObject.doctor
        self.photoFileNames = newObject.photoFileNames
        self.title = newObject.title
        self.drugsID = newObject.drugs.compactMap { $0.coreID }
        return self
    }
    
}
