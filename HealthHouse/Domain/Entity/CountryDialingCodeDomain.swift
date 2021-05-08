//
//  CountryDialingCodeDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation

public struct CountryDialingCodeDomain {
    
    public let code: String
    public let dialCode: String
    public let flag: String
    public let name: String
    
}

extension CountryDialingCodeDomain: Equatable {
    
    public static func == (lhs: CountryDialingCodeDomain, rhs: CountryDialingCodeDomain) -> Bool {
        return lhs.dialCode == rhs.dialCode
    }
    
}

extension CountryDialingCodeDomain {
    
    public static var indonesia: CountryDialingCodeDomain {
        return CountryDialingCodeDomain(code: "ID", dialCode: "+62", flag: "🇮🇩", name: "Indonesia")
    }
    
}

extension Array where Element == CountryDialingCodeDomain {
    
    func row(of element: CountryDialingCodeDomain) -> Int? {
        var row: Int? = nil
        for (r, e) in self.enumerated() {
            if e == element {
                row = r
            }
        }
        return row
    }
    
}
