//
//  FlagDomain.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import Foundation
@testable import Health_House

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
