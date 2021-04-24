//
//  ProfileEntity+CoreDataProperties.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData


extension ProfileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileEntity> {
        return NSFetchRequest<ProfileEntity>(entityName: "ProfileEntity")
    }

    @NSManaged public var createdAt: Int64
    @NSManaged public var updatedAt: Int64
    
    @NSManaged public var dateOfBirth: Int64
    @NSManaged public var firstName: String
    @NSManaged public var gender: String
    @NSManaged public var lastName: String?
    @NSManaged public var mobileNumber: String
    @NSManaged public var photoBase64String: String?
    
    @NSManaged public var activitiesID: [NSManagedObjectID]
    @NSManaged public var diseasesID: [NSManagedObjectID]

}

extension ProfileEntity: Identifiable {

}
