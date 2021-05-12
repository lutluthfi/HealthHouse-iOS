//
//  UIColor+HexString.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 10/05/21.
//

import UIKit

public extension UIColor {
    
    /// Initialize UIColor with a hex of string.
    ///
    /// Usage
    ///
    ///     let whiteColor = UIColor(hex: "FFFFFF")
    ///
    /// - Author:
    ///   Arif Luthfiansyah
    ///
    /// - Parameters:
    ///   - hex: A string that indicates of a hex color value. Must be six digit characters.
    ///   - alpha: A decimal number that indicates the transparency value of the color. Default is 1.0.
    ///
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var _hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        _hex.removeAll(where: { $0.isPunctuation })
        
        if _hex.hasPrefix("#") {
            _hex.removeFirst()
        }
        
        if _hex.count != 6 {
            self.init(hex: "FFFFFF")
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: _hex).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}

public extension UIColor {
    
    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int) (r * 255) << 16 | (Int) (g * 255) << 8 | (Int) (b * 255) << 0
        
        return String(format: "%06x", rgb).uppercased()
    }
    
}
