//
//  ActivityEntity+CoreDataClass.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData

@objc(ActivityEntity)
public class ActivityEntity: NSManagedObject {

    public static let entityName = String(describing: ActivityEntity.self)
    
    public convenience init(_ domain: ActivityDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.photoFileNames = domain.photoFileNames
        self.doDate = domain.doDate
        self.explanation = domain.explanation
        self.isArchived = domain.isArchived
        self.isPinned = domain.isPinned
        self.title = domain.title
        
        self.labelID = domain.profile.coreID!
        self.profileID = domain.profile.coreID!
    }
    
}

public extension ActivityEntity {
    
    func toDomain(context: NSManagedObjectContext) -> ActivityDomain {
        let profile = context.object(with: self.profileID) as! ProfileEntity
        var label: LabelEntity?
        if let labelID = self.labelID,
           let _label = context.object(with: labelID) as? LabelEntity {
            label = _label
        } else {
            label = nil
        }
        return ActivityDomain(coreID: self.objectID,
                              createdAt: self.createdAt,
                              updatedAt: self.updatedAt,
                              doDate: self.doDate,
                              explanation: self.explanation,
                              isArchived: self.isArchived,
                              isPinned: self.isPinned,
                              photoFileNames: self.photoFileNames,
                              title: self.title,
                              label: label?.toDomain(),
                              profile: profile.toDomain())
    }
    
}

extension ActivityEntity {
    
    @discardableResult
    func createUpdate(with newObject: ActivityDomain, context: NSManagedObjectContext) -> ActivityEntity {
        guard self.objectID == newObject.coreID else {
            return ActivityEntity(newObject, insertInto: context)
        }
        self.updatedAt = Date().toInt64()
        self.doDate = newObject.doDate
        self.explanation = newObject.explanation
        self.isArchived = newObject.isArchived
        self.isPinned = newObject.isPinned
        self.photoFileNames = newObject.photoFileNames
        self.title = newObject.title
        
        self.labelID = newObject.label?.coreID
        self.profileID = newObject.profile.coreID!
        
        return self
    }
    
}
