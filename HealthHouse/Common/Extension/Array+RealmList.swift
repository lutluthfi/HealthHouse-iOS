//
//  Array+RealmList.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 21/06/21.
//

import Foundation
import RealmSwift

extension List {
    
    var asArray: [Element] {
        var arr: [Element] = []
        self.forEach { arr.append($0) }
        return arr
    }
    
}
