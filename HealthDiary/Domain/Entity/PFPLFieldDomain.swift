//
//  PFPLFieldDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import Foundation

public struct PFPLFieldDomain {
    
    public static let firstName = PFPLFieldDomain(placeholder: "First Name")
    public static let lastName = PFPLFieldDomain(placeholder: "Last Name")
    public static let dateOfBirth = PFPLFieldDomain(placeholder: "Date of Birth")
    public static let gender = PFPLFieldDomain(placeholder: "Gender")
    public static let mobileNumber = PFPLFieldDomain(placeholder: "Mobile Number")
    public static let photo = PFPLFieldDomain(placeholder: "Photo")
    
    public let placeholder: String
    
}

extension PFPLFieldDomain: Equatable {
    
    public static func == (lhs: PFPLFieldDomain, rhs: PFPLFieldDomain) -> Bool {
        return lhs.placeholder == rhs.placeholder
    }
    
}
