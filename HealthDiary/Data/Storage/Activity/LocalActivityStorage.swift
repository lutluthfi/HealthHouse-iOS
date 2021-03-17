//
//  LocalActivityStorage.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 17/03/21.
//

import Foundation

public protocol LocalActivityStorage: ActivityStorage {
    
    
    
}

public class DefaultLocalActivityStorage {
    
    let coreDataStorage: CoreDataStorageShared
    
    public init(coreDataStorage: CoreDataStorageShared = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
}

extension DefaultLocalActivityStorage: LocalActivityStorage {
    
}
