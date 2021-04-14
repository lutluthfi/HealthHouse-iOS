//
//  ProfileEntity+CoreDataClass.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//
//

import Foundation
import CoreData

@objc(ProfileEntity)
public class ProfileEntity: NSManagedObject {

    public static let entityName = String(describing: ProfileEntity.self)
    
    public convenience init(_ domain: ProfileDomain, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = domain.createdAt
        self.updatedAt = domain.updatedAt
        
        self.dateOfBirth = domain.dateOfBirth
        self.firstName = domain.firstName
        self.lastName = domain.lastName
        self.mobileNumber = domain.mobileNumbder
        self.photoFileName = domain.photoFileName
    }
    
}

public extension ProfileEntity {
    
    func toDomain() -> ProfileDomain {
        return ProfileDomain(coreID: self.objectID,
                             createdAt: self.createdAt,
                             updatedAt: self.updatedAt,
                             dateOfBirth: self.dateOfBirth,
                             firstName: self.firstName,
                             gender: GenderDomain(rawValue: self.gender),
                             lastName: self.lastName,
                             mobileNumbder: self.mobileNumber,
                             photoFileName: self.photoFileName)
    }
    
}

extension ProfileEntity {
    
    @discardableResult
    func createUpdate(with newObject: ProfileDomain, context: NSManagedObjectContext) -> ProfileEntity {
        guard self.objectID == newObject.coreID else {
            return ProfileEntity(newObject, insertInto: context)
        }
        self.updatedAt = Date().toInt64()
        self.dateOfBirth = newObject.dateOfBirth
        self.firstName = newObject.firstName
        self.gender = newObject.gender.rawValue
        self.lastName = newObject.lastName
        self.mobileNumber = newObject.mobileNumbder
        self.photoFileName = newObject.photoFileName
        return self
    }
    
}
