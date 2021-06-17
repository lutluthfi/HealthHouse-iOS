//
//  RealmList+Array.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 09/06/21.
//

import Foundation
import RealmSwift

extension Array where Element: Object {
    
    func toRealm() -> List<Element> {
        let list = List<Element>()
        self.forEach { list.append($0) }
        return list
    }
    
}

extension Array where Element: RealmCollectionValue {
    
    func toRealm() -> List<Element> {
        let list = List<Element>()
        self.forEach { list.append($0) }
        return list
    }
    
}