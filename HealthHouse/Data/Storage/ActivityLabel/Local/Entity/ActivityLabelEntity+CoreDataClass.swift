//
//  ActivityLabelEntity+CoreDataClass.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 02/05/21.
//
//

import Foundation
import CoreData

@objc(ActivityLabelEntity)
public class ActivityLabelEntity: NSManagedObject {

    public static let entityName = String(describing: ActivityLabelEntity.self)
    
    public convenience init(_ domain: ActivityLabelDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.activityID = domain.activity.coreID!
        self.labelsID = domain.labels.compactMap({ $0.coreID })
    }
    
}

extension ActivityLabelEntity {
    
    func toDomain(context: NSManagedObjectContext) -> ActivityLabelDomain {
        let activityEntity = context.object(with: self.activityID) as! ActivityEntity
        let labelEntities = self.labelsID.compactMap({ context.object(with: $0) as? FlagEntity })
        let activityDomain = activityEntity.toDomain(context: context)
        let labelDomains = labelEntities.map({ $0.toDomain() })
        return ActivityLabelDomain(coreID: self.objectID,
                                   createdAt: self.createdAt,
                                   updatedAt: self.updatedAt,
                                   activity: activityDomain,
                                   labels: labelDomains)
    }
    
}
