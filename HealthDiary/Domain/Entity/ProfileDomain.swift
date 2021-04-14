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
    public let lastName: String
    public let mobileNumbder: String
    public let photoFileName: String
    
    public var fullName: String {
        if self.lastName.isEmpty {
            return self.firstName
        } else {
            return "\(self.firstName) \(self.lastName)"
        }
    }
    public var photoURL: URL? {
        let directoryURL = FileKit.local.localProfilePhotosDirectoryURL
        return directoryURL.appendingPathComponent(self.photoFileName, isDirectory: false)
    }
    
}

extension ProfileDomain: Equatable {
    
    public static func == (lhs: ProfileDomain, rhs: ProfileDomain) -> Bool {
        return lhs.coreID == rhs.coreID
    }
    
}
