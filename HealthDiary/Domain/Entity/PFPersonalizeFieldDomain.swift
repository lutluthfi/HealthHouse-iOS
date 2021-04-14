//
//  PFPersonalizeFieldDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import Foundation

public struct PFPersonalizeFieldDomain {
    
    public static let firstName = PFPersonalizeFieldDomain(placeholder: "First Name")
    public static let lastName = PFPersonalizeFieldDomain(placeholder: "Last Name")
    public static let dateOfBirth = PFPersonalizeFieldDomain(placeholder: "Date of Birth")
    public static let gender = PFPersonalizeFieldDomain(placeholder: "Gender")
    public static let mobileNumber = PFPersonalizeFieldDomain(placeholder: "Mobile Number")
    public static let photo = PFPersonalizeFieldDomain(placeholder: "Photo")
    
    public let placeholder: String
    
}

extension PFPersonalizeFieldDomain: Equatable {
    
    public static func == (lhs: PFPersonalizeFieldDomain, rhs: PFPersonalizeFieldDomain) -> Bool {
        return lhs.placeholder == rhs.placeholder
    }
    
}
