//
//  String+RealmPrimaryKey.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 09/06/21.
//

import Foundation

extension Optional where Wrapped == String {
    
    var orMakePrimaryKey: String {
        if let self = self {
            return self
        } else {
            return UUID().uuidString
        }
    }
    
}
