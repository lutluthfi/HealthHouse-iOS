//
//  FieldDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import Foundation
import RxDataSources

public struct FieldDomain {
    
    public static let attachment = FieldDomain(placeholder: "Attachment")
    public static let date = FieldDomain(placeholder: "Date")
    public static let datePicker = FieldDomain(placeholder: "Date Picker")
    public static let explanation = FieldDomain(placeholder: "Explanation")
    public static let firstName = FieldDomain(placeholder: "First Name")
    public static let lastName = FieldDomain(placeholder: "Last Name")
    public static let dateOfBirth = FieldDomain(placeholder: "Date of Birth")
    public static let gender = FieldDomain(placeholder: "Gender")
    public static let label = FieldDomain(placeholder: "Label")
    public static let location = FieldDomain(placeholder: "Location")
    public static let mobileNumber = FieldDomain(placeholder: "Mobile Number")
    public static let photo = FieldDomain(placeholder: "Photo")
    public static let practitioner = FieldDomain(placeholder: "Practitioner")
    public static let time = FieldDomain(placeholder: "Time")
    public static let title = FieldDomain(placeholder: "Title")
    public static let timePicker = FieldDomain(placeholder: "Time Picker")
    
    public let placeholder: String
    
}

extension FieldDomain: Equatable {
    
    public static func == (lhs: FieldDomain, rhs: FieldDomain) -> Bool {
        return lhs.placeholder == rhs.placeholder
    }
    
}

extension FieldDomain: IdentifiableType {
    
    public typealias Identity = String
    
    public var identity: String {
        return self.placeholder
    }
    
}
