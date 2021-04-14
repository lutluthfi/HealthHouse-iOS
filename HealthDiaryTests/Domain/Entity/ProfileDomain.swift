//
//  ProfileDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import XCTest
@testable import DEV_Health_Diary

extension ProfileDomain {
    
    static var stubElement: ProfileDomain {
        let now = Date()
        return ProfileDomain(coreID: nil,
                             createdAt: now.toInt64(),
                             updatedAt: now.toInt64(),
                             dateOfBirth: now.toInt64(),
                             firstName: "Stub Element",
                             gender: .male,
                             lastName: "Stub Element",
                             mobileNumbder: "1234567890",
                             photoFileName: "Stub Element")
    }
    
    static var stubElementInsertedIntoCoreData: ProfileDomain {
        let coreDataStorage = CoreDataStorageMock()
        let insertedProfileEntity = ProfileEntity(.stubElement, insertInto: coreDataStorage.context)
        coreDataStorage.saveContext()
        return insertedProfileEntity.toDomain()
    }
    
}
