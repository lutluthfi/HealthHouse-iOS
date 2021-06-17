//
//  ProfileRealm.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 06/06/21.
//

import Foundation
import RealmSwift

@objc final class ProfileRealm: Object {
    
    @objc dynamic var ID: ProfileID = ""
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    
    @objc dynamic var dateOfBirth: Int64 = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var gender: String = ""
    @objc dynamic var lastName: String?
    @objc dynamic var mobileNumber: String = ""
    @objc dynamic var photoBase64String: String?
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
    convenience init(ID: ProfileID,
                     createdAt: Int64,
                     updatedAt: Int64,
                     dateOfBirth: Int64,
                     firstName: String,
                     gender: String,
                     lastName: String?,
                     mobileNumber: String,
                     photoBase64String: String?) {
        self.init()
        self.ID = ID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        self.dateOfBirth = dateOfBirth
        self.firstName = firstName
        self.gender = gender
        self.lastName = lastName
        self.mobileNumber = mobileNumber
        self.photoBase64String = photoBase64String
    }
    
}

extension Array where Element == ProfileRealm {
    
    func toDomain() -> [Profile] {
        return self.compactMap({ $0.toDomain() })
    }
    
}

extension ProfileRealm {
    
    func toDomain() -> Profile {
        return Profile(realmID: self.ID,
                             createdAt: self.createdAt,
                             updatedAt: self.updatedAt,
                             dateOfBirth: self.dateOfBirth,
                             firstName: self.firstName,
                             gender: GenderDomain(rawValue: self.gender),
                             lastName: self.lastName,
                             mobileNumbder: self.mobileNumber,
                             photoBase64String: self.photoBase64String)
    }
    
}

extension Profile {
    
    func toRealm() -> ProfileRealm {
        return ProfileRealm(ID: self.realmID,
                            createdAt: self.createdAt,
                            updatedAt: self.updatedAt,
                            dateOfBirth: self.dateOfBirth,
                            firstName: self.firstName,
                            gender: self.gender.rawValue,
                            lastName: self.lastName,
                            mobileNumber: self.mobileNumbder,
                            photoBase64String: self.photoBase64String)
    }
    
}
