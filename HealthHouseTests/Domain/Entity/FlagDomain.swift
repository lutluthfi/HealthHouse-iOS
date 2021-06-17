//
//  Flag.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import XCTest
@testable import Health_House

// MARK: StubCollection
extension FlagDomain {
    
    @discardableResult
    static func stubCollectionCoreData(coreDataStorage: CoreDataStorageSharedMock) -> [FlagDomain] {
        let now = Date()
        let flags = [FlagDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                hexcolor: UIColor.red.hexString(),
                                name: "Flag Stub Collection 1"),
                     FlagDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                hexcolor: UIColor.red.hexString(),
                                name: "Flag Stub Collection 2"),
                     FlagDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                hexcolor: UIColor.red.hexString(),
                                name: "Flag Stub Collection 3"),
                     FlagDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                hexcolor: UIColor.red.hexString(),
                                name: "Flag Stub Collection 4"),
                     FlagDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                hexcolor: UIColor.red.hexString(),
                                name: "Flag Stub Collection 5")]
        let entities = flags.map { FlagEntity($0, insertInto: coreDataStorage.context) }
        coreDataStorage.saveContext()
        let _flags = entities.map { $0.toDomain() }
        return _flags
    }
    
}

// MARK: StubElement
extension FlagDomain {
    
    static var stubElement: FlagDomain {
        let now = Date()
        let label = FlagDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                hexcolor: "000",
                                name: "Label Stub Element")
        return label
    }
    
    @discardableResult
    static func stubElementCoreData(coreDataStorage: CoreDataStorageSharedMock) -> FlagDomain {
        let context = coreDataStorage.context
        let now = Date()
        let label = FlagDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                hexcolor: "000",
                                name: "Label Stub Element Core Data")
        let entity = FlagEntity(label, insertInto: context)
        coreDataStorage.saveContext()
        let _activity = entity.toDomain()
        return _activity
    }
    
}
