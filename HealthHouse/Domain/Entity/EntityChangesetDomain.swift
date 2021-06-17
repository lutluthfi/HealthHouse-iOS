//
//  EntityChangesetDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 06/06/21.
//

import Foundation
import RxRealm

typealias Changeset = RealmChangeset

struct EntityChangesetDomain<Entity: EntityDomain> {
    
    let entities: [Entity]
    let changeset: RealmChangeset
    
}
