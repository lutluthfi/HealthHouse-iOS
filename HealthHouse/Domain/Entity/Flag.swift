//
//  Flag.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation
import RxDataSources

typealias FlagID = String

struct Flag: EntityDomain {
    
    let realmID: FlagID
    let createdAt: Int64
    let updatedAt: Int64
    
    let hexcolor: String
    let name: String
    
}

extension Flag: Equatable {
    
    static func == (lhs: Flag, rhs: Flag) -> Bool {
        return lhs.realmID == rhs.realmID && lhs.name == rhs.name
    }
    
}

extension Flag: IdentifiableType {
    
    typealias Identity = String
    
    var identity: String {
        return self.name
    }
    
}

extension Flag {
    
    func toSelectableItem(selected: Bool) -> SelectableDomain<Flag> {
        return SelectableDomain(identify: self.name, selected: selected, value: self)
    }
    
}

extension Array where Element == Flag {
    
    func toSelectableItems(selectedFlags: [Flag]) -> [SelectableDomain<Flag>] {
        return self.map({ $0.toSelectableItem(selected: selectedFlags.contains($0)) })
    }
    
}
