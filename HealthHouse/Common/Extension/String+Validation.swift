//
//  String+Validation.swift
//  HealthDiary
//
//  Created by Arif Luthfiansyah on 16/04/21.
//

import Foundation

extension String {
    
    enum Validation {
        case emoji
        case number
        case specialCharacter
    }
    
    func contains(_ validations: [Validation]) -> Bool {
        var res: [Bool] = []
        validations.forEach { validation in
            switch validation {
            case .emoji:
                let isContains = self.contains(where: { (character) in
                    guard let scalar = character.unicodeScalars.first else { return false }
                    return scalar.properties.isEmoji && (scalar.value > 0x238C || unicodeScalars.count > 1)
                })
                res.append(isContains)
            case .number:
                let isContains = self.contains(where: { $0.isNumber })
                res.append(isContains)
            case .specialCharacter:
                let characters = CharacterSet(charactersIn: "~!@#$%^&*()_+`{}|[]\\;':\",./<>?")
                let range = self.rangeOfCharacter(from: characters)
                let isRangeEmpty = range?.isEmpty == true
                let isContainSpecialCharacter = range != nil && !isRangeEmpty
                res.append(isContainSpecialCharacter)
            }
        }
        return res.reduce(false) { $0 || $1 }
    }
    
}
