//
//  ProfileDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

public struct ProfileDomain: EntityDomain {
    
    public let coreID: CoreID?
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let dateOfBirth: Int64
    public let firstName: String
    public let gender: GenderDomain
    public let lastName: String?
    public let mobileNumbder: String
    public let photoBase64String: String?
    
    public var fullName: String {
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

extension ProfileDomain: Equatable {
    
    public static func == (lhs: ProfileDomain, rhs: ProfileDomain) -> Bool {
        return lhs.coreID == rhs.coreID
    }
    
}
