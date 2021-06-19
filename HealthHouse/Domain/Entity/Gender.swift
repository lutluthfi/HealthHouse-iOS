//
//  Gender.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import Foundation

public enum Gender: String, CaseIterable {
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
