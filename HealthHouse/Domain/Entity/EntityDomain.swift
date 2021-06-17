//
//  EntityDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation
import RxRealm

protocol EntityDomain {
    
    var realmID: String { get }
    var createdAt: Int64 { get }
    var updatedAt: Int64 { get }
    
}
