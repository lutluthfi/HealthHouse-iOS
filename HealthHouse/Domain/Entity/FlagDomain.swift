//
//  FlagDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation
import RxDataSources

public struct FlagDomain: EntityDomain {
    
    public let coreID: CoreID?
    public let createdAt: Int64
    public let updatedAt: Int64
    
    public let hexcolor: String
    public let name: String
    
}

extension FlagDomain: Equatable {
    
    public static func == (lhs: FlagDomain, rhs: FlagDomain) -> Bool {
        return lhs.coreID == rhs.coreID && lhs.name == rhs.name
    }
    
}

extension FlagDomain: IdentifiableType {
    
    public typealias Identity = String
    
    public var identity: String {
        return self.name
    }
    
}
