//
//  LabelDomain.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 02/05/21.
//

import Foundation
@testable import Health_House

// MARK: StubElement
extension LabelDomain {
    
    static var stubElement: LabelDomain {
        let now = Date()
        let label = LabelDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                name: "Label Stub Element")
        return label
    }
    
    @discardableResult
    static func stubElementCoreData(coreDataStorage: CoreDataStorageSharedMock) -> LabelDomain {
        let context = coreDataStorage.context
        let now = Date()
        let label = LabelDomain(coreID: nil,
                                createdAt: now.toInt64(),
                                updatedAt: now.toInt64(),
                                name: "Label Stub Element Core Data")
        let entity = LabelEntity(label, insertInto: context)
        coreDataStorage.saveContext()
        let _activity = entity.toDomain()
        return _activity
    }
    
}
