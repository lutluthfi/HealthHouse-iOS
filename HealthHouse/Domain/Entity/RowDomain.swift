//
//  RowDomain.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 01/04/21.
//

import Foundation
import RxDataSources

public struct RowDomain {
    
    public static var attachment: RowDomain {
        return RowDomain(identify: "Attachment", value: "Attachment")
    }
    public static var date: RowDomain {
        return RowDomain(identify: "Date", value: "Date")
    }
    public static var datePicker: RowDomain {
        return RowDomain(identify: "Date Picker", value: "Date Picker")
    }
    public static var explanation: RowDomain {
        return RowDomain(identify: "Explanation", value: "Explanation")
    }
    public static var firstName: RowDomain {
        return RowDomain(identify: "First Name", value: "First Name")
    }
    public static var lastName: RowDomain {
        return RowDomain(identify: "Last Name", value: "Last Name")
    }
    public static var dateOfBirth: RowDomain {
        return RowDomain(identify: "Date of Birth", value: "Date of Birth")
    }
    public static var flag: RowDomain {
        return RowDomain(identify: "Flag", value: [])
    }
    public static var gender: RowDomain {
        return RowDomain(identify: "Gender", value: "Gender")
    }
    public static var location: RowDomain {
        return RowDomain(identify: "Location", value: "Location")
    }
    public static var mobileNumber: RowDomain {
        return RowDomain(identify: "Mobile Number", value: "Mobile Number")
    }
    public static var photo: RowDomain {
        return RowDomain(identify: "Photo", value: "Photo")
    }
    public static var practitioner: RowDomain {
        return RowDomain(identify: "Practitioner", value: "Practitioner")
    }
    public static var time: RowDomain {
        return RowDomain(identify: "Time", value: "Time")
    }
    public static var title: RowDomain {
        return RowDomain(identify: "Title", value: "Title")
    }
    public static var timePicker: RowDomain {
        return RowDomain(identify: "Time Picker", value: "Time Picker")
    }
    
    public let identify: String
    public var value: Any
    
}

extension RowDomain: Equatable {
    
    public static func == (lhs: RowDomain, rhs: RowDomain) -> Bool {
        return lhs.identify == rhs.identify
    }
    
}

extension RowDomain: IdentifiableType {
    
    public typealias Identity = String
    
    public var identity: String {
        return self.identify
    }
    
}
