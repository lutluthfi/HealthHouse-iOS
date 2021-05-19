//
//  UIColorInputError.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 19/05/21.
//

import Foundation

/// - Author: *https://github.com/yeahdongcn/UIColor-Hex-Swift*
public enum UIColorInputError: Error {
    case missingHashMarkAsPrefix(String)
    case unableToScanHexValue(String)
    case mismatchedHexStringLength(String)
    case unableToOutputHexStringForWideDisplayColor
}

extension UIColorInputError: LocalizedError {
    
    /// A description from `UIColorInputError`
    ///
    /// The description will consist of these:
    ///
    /// • Invalid RGB string, missing '#' as prefix in *hex*. (`missingHashMarkAsPrefix`)
    ///
    /// • Scan *hex* error. (`unableToScanHexValue`)
    ///
    /// • Invalid RGB string from *hex*, number of characters after '#' should be either 3, 4, 6 or 8. (`mismatchedHexStringLength`)
    ///
    /// • Unable to output hex string for wide display color. (`unableToOutputHexStringForWideDisplayColor`)
    ///
    /// - Author:
    ///   - *https://github.com/yeahdongcn/UIColor-Hex-Swift*
    public var errorDescription: String? {
        switch self {
        case .missingHashMarkAsPrefix(let hex):
            return "Invalid RGB string, missing '#' as prefix in \(hex)"
        case .unableToScanHexValue(let hex):
            return "Scan \(hex) error"
        case .mismatchedHexStringLength(let hex):
            return "Invalid RGB string from \(hex), number of characters after '#' should be either 3, 4, 6 or 8"
        case .unableToOutputHexStringForWideDisplayColor:
            return "Unable to output hex string for wide display color"
        }
    }
    
}
