//
//  SectionDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 29/04/21.
//

import Foundation
import RxDataSources

// MARK: SectionDomain
public struct SectionDomain<Item: Equatable&IdentifiableType> {
    
    public var footer: String?
    public var header: String
    public var items: [Item]
    
}

extension SectionDomain: SectionModelType, AnimatableSectionModelType {
    
    public var identity: String {
        return self.header
    }
    
    public init(original: SectionDomain, items: [Item]) {
        self = original
        self.items = items
    }
    
}
