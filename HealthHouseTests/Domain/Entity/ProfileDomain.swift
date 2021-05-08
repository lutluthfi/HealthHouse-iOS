//
//  ProfileDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import XCTest
@testable import Health_House

extension ProfileDomain {
    
    static var stubCollection: [ProfileDomain] {
        let now = Date()
        return [ProfileDomain(coreID: nil,
                              createdAt: now.toInt64(),
                              updatedAt: now.toInt64(),
                              dateOfBirth: now.toInt64(),
                              firstName: "Stub Element 1",
                              gender: .male,
                              lastName: "Stub Element 1",
                              mobileNumbder: "1234567890",
                              photoBase64String: "Stub Element"),
                ProfileDomain(coreID: nil,
                              createdAt: now.toInt64(),
                              updatedAt: now.toInt64(),
                              dateOfBirth: now.toInt64(),
                              firstName: "Stub Element 2",
                              gender: .male,
                              lastName: "Stub Element 2",
                              mobileNumbder: "1234567890",
                              photoBase64String: "Stub Element"),
                ProfileDomain(coreID: nil,
                              createdAt: now.toInt64(),
                              updatedAt: now.toInt64(),
                              dateOfBirth: now.toInt64(),
                              firstName: "Stub Element 3",
                              gender: .male,
                              lastName: "Stub Element 3",
                              mobileNumbder: "1234567890",
                              photoBase64String: "Stub Element")]
    }
    
    @discardableResult
    static func stubCollectionCoreData(coreDataStorage: CoreDataStorageSharedMock) -> [ProfileDomain] {
        let insertedProfileEntities = ProfileDomain.stubCollection.map {
            ProfileEntity($0, insertInto: coreDataStorage.context)
        }
        coreDataStorage.saveContext()
        return insertedProfileEntities.map { $0.toDomain() }.sorted(by: { $0.firstName < $1.firstName })
    }
    
}

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
                             photoBase64String: "Stub Element")
    }
    
    @discardableResult
    static func stubElementCoreData(coreDataStorage: CoreDataStorageSharedMock) -> ProfileDomain {
        let insertedProfileEntity = ProfileEntity(.stubElement, insertInto: coreDataStorage.context)
        coreDataStorage.saveContext()
        return insertedProfileEntity.toDomain()
    }
    
}
