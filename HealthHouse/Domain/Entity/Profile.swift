//
//  Profile.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

typealias ProfileID = String

struct Profile: EntityDomain {
    
    let realmID: ProfileID
    let createdAt: Int64
    let updatedAt: Int64
    
    let dateOfBirth: Int64
    let firstName: String
    let gender: Gender
    let lastName: String?
    let mobileNumbder: String
    let photoBase64String: String?
    
    let allergies: [Allergy]
    
    var fullName: String {
        guard let lastName = self.lastName else {
            return self.firstName
        }
        if lastName.isEmpty {
            return self.firstName
        } else {
            return "\(self.firstName) \(lastName)"
        }
    }
    
}

extension Profile: Equatable {
    
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.realmID == rhs.realmID
    }
    
}
