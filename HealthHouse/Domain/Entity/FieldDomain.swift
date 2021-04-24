//
//  FieldDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import Foundation

public struct FieldDomain {
    
    public static let firstName = FieldDomain(placeholder: "First Name")
    public static let lastName = FieldDomain(placeholder: "Last Name")
    public static let dateOfBirth = FieldDomain(placeholder: "Date of Birth")
    public static let gender = FieldDomain(placeholder: "Gender")
    public static let mobileNumber = FieldDomain(placeholder: "Mobile Number")
    public static let photo = FieldDomain(placeholder: "Photo")
    
    public let placeholder: String
    
}

extension FieldDomain: Equatable {
    
    public static func == (lhs: FieldDomain, rhs: FieldDomain) -> Bool {
        return lhs.placeholder == rhs.placeholder
    }
    
}
