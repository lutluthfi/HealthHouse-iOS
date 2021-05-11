//
//  UIColorHexStringTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 11/05/21.
//

import XCTest
@testable import Health_House

class UIColorHexStringTests: XCTestCase {
    
    func test_hex() {
        let color = UIColor.white
        
        XCTAssertEqual(color.hex, "FFFFFF")
    }
    
    func test_init_shouldHexValid() {
        let color = UIColor(hex: "000000")
        
        XCTAssertEqual(color.rgba.red, UIColor.black.rgba.red)
        XCTAssertEqual(color.rgba.green, UIColor.black.rgba.green)
        XCTAssertEqual(color.rgba.blue, UIColor.black.rgba.blue)
    }
    
    func test_init_whenHexNotValid_thenColorWillWhite() {
        let color = UIColor(hex: "!@#")
        
        XCTAssertEqual(color.rgba.red, UIColor.white.rgba.red)
        XCTAssertEqual(color.rgba.green, UIColor.white.rgba.green)
        XCTAssertEqual(color.rgba.blue, UIColor.white.rgba.blue)
    }

    func test_init_whenHexNotSixDigitCharacters_thenColorWillWhite() {
        let color = UIColor(hex: "fff")
         
        XCTAssertEqual(color.rgba.red, UIColor.white.rgba.red)
        XCTAssertEqual(color.rgba.green, UIColor.white.rgba.green)
        XCTAssertEqual(color.rgba.blue, UIColor.white.rgba.blue)
    }

}
