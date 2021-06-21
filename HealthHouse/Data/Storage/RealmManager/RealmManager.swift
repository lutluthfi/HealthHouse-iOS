//
//  RealmManager.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 05/06/21.
//

import Foundation
import RealmSwift

protocol RealmManagerShared {
    var configuration: Realm.Configuration { get }
    var realm: Realm { get }
    var schemaVersion: UInt64 { get }
}

final class RealmManager {
    
    var _configuration = Realm.Configuration.defaultConfiguration
    var _realm: Realm!
    
    private init() {
    }
    
    static func sharedInstance(config: Realm.Configuration = Realm.Configuration.defaultConfiguration) -> RealmManagerShared {
        let instance = RealmManager()
        instance._configuration = config
        instance._realm = try! Realm(configuration: config)
        return instance
    }
    
}

extension RealmManager: RealmManagerShared {
    
    var configuration: Realm.Configuration {
        get {
            return self._configuration
        }
    }
    
    var realm: Realm {
        return self._realm
    }
    
    var schemaVersion: UInt64 {
        return self._configuration.schemaVersion
    }
    
}
