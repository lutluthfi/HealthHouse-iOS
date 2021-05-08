//
//  RemoteCountryDialingCodeEntity+Response.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 03/04/21.
//

import Foundation

extension RemoteCountryDialingCodeEntity {
    
    public struct Response: Decodable {
        
        public let code: String
        public let dialCode: String
        public let flag: String
        public let name: String
        
        enum CodingKeys: String, CodingKey {
            case code
            case dialCode = "dial_code"
            case flag
            case name
        }
        
    }
    
}

public extension RemoteCountryDialingCodeEntity.Response {
    
    func toDomain() -> CountryDialingCodeDomain {
        return CountryDialingCodeDomain(code: self.code, dialCode: self.dialCode, flag: self.flag, name: self.name)
    }
    
}
