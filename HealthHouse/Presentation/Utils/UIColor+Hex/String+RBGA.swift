//
//  String+Argb.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 19/05/21.
//

import Foundation

extension String {
    
    /// Convert argb string to rgba string.
    ///
    /// - Author: *https://github.com/yeahdongcn/UIColor-Hex-Swift*
    public var argb2rgba: String? {
        guard self.hasPrefix("#") else {
            return nil
        }
        
        let hexString: String = String(self[self.index(self.startIndex, offsetBy: 1)...])
        switch hexString.count {
        case 4:
            return "#\(String(hexString[self.index(self.startIndex, offsetBy: 1)...]))\(String(hexString[..<self.index(self.startIndex, offsetBy: 1)]))"
        case 8:
            return "#\(String(hexString[self.index(self.startIndex, offsetBy: 2)...]))\(String(hexString[..<self.index(self.startIndex, offsetBy: 2)]))"
        default:
            return nil
        }
    }
    
}
