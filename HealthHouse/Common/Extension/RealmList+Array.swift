//
//  RealmList+Array.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 09/06/21.
//

import Foundation
import RealmSwift

extension Array where Element: Object {
    
    var asRealmList: List<Element> {
        let list = List<Element>()
        self.forEach { list.append($0) }
        return list
    }
    
}

extension Array where Element: RealmCollectionValue {
    
    var asRealmList: List<Element> {
        let list = List<Element>()
        self.forEach { list.append($0) }
        return list
    }
    
}
