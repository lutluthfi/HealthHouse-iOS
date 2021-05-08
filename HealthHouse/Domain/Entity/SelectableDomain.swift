//
//  SelectableDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 08/05/21.
//

import Foundation
import RxDataSources

public struct SelectableDomain<Value> {
    
    public let identify: String
    public let selected: Bool
    public let value: Value
    
}

extension SelectableDomain: Equatable {
    
    public static func == (lhs: SelectableDomain, rhs: SelectableDomain) -> Bool {
        return lhs.identify == rhs.identify
    }
    
}

extension SelectableDomain: IdentifiableType {
    
    public typealias Identity = String
    
    public var identity: String {
        return self.identify
    }
    
}
