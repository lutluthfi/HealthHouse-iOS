//
//  Optional+Unwrap.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 17/06/21.
//

import Foundation

extension Optional where Wrapped: ExpressibleByArrayLiteral {
    
    var orEmpty: Wrapped {
        if let self = self {
            return self
        } else {
            return []
        }
    }
    
    func unwrap(_ def: Wrapped) -> Wrapped {
        if let self = self {
            return self
        } else {
            return def
        }
    }
    
}

extension Optional where Wrapped: ExpressibleByBooleanLiteral {
    
    var orFalse: Wrapped {
        if let self = self {
            return self
        } else {
            return false
        }
    }
    
    func unwrap(_ def: Wrapped) -> Wrapped {
        if let self = self {
            return self
        } else {
            return def
        }
    }
    
}

extension Optional where Wrapped: ExpressibleByDictionaryLiteral {
    
    var orEmpty: Wrapped {
        if let self = self {
            return self
        } else {
            return [:]
        }
    }
    
    func unwrap(_ def: Wrapped) -> Wrapped {
        if let self = self {
            return self
        } else {
            return def
        }
    }
    
}

extension Optional where Wrapped: ExpressibleByFloatLiteral {
    
    var orZero: Wrapped {
        if let self = self {
            return self
        } else {
            return 0.0
        }
    }
    
    func unwrap(_ def: Wrapped) -> Wrapped {
        if let self = self {
            return self
        } else {
            return def
        }
    }
    
}

extension Optional where Wrapped: ExpressibleByIntegerLiteral {
    
    var orZero: Wrapped {
        if let self = self {
            return self
        } else {
            return 0
        }
    }
    
    func unwrap(_ def: Wrapped) -> Wrapped {
        if let self = self {
            return self
        } else {
            return def
        }
    }
    
}

extension Optional where Wrapped: ExpressibleByStringLiteral {
    
    var orEmpty: Wrapped {
        if let self = self {
            return self
        } else {
            return ""
        }
    }
    
    func unwrap(_ def: Wrapped) -> Wrapped {
        if let self = self {
            return self
        } else {
            return def
        }
    }
    
}
