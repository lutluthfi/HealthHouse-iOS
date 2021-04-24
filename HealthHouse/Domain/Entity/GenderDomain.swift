//
//  GenderDomain.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

public enum GenderDomain: String, CaseIterable {
    case male = "male"
    case female = "female"
    
    public init(rawValue: String) {
        switch rawValue.lowercased() {
        case "male":
            self = .male
        case "female":
            self = .female
        default:
            self = .male
        }
    }
}
