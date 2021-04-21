//
//  StringValidationTests.swift
//  HealthDiaryTests
//
//  Created by Arif Luthfiansyah on 17/04/21.
//

import XCTest
@testable import DEV_Health_Diary

class StringValidationTests: XCTestCase {

    func test_contains_whenStringNotContainsAny_thenResultTrue() {
        let str = "To the moon"
        
        let result = str.contains([.emoji, .number, .specialCharacter])
        
        XCTAssertFalse(result)
    }
    
    func test_contains_whenStringContainsEmoji_thenResultTrue() {
        let str = "To the moon 🚀"
        
        let result = str.contains([.emoji])
        
        XCTAssertTrue(result)
    }
    
    func test_contains_whenStringContainsNumber_thenResultTrue() {
        let str = "To the moon 123456780"
        
        let result = str.contains([.number])
        
        XCTAssertTrue(result)
    }
    
    func test_contains_whenStringContainsSpecialCharacter_thenResultTrue() {
        let str = "To the moon ~!@#$%^&*()_+`[] \\ { } |"
        
        let result = str.contains([.specialCharacter])
        
        XCTAssertTrue(result)
    }
    
    func test_contains_whenStringContainsEmojiAndNumber_thenResultTrue() {
        let str = "To the moon 🚀 123"
        
        let result = str.contains([.emoji, .number])
        
        XCTAssertTrue(result)
    }
    
    func test_contains_whenStringContainsEmojiAndSpecialCharacter_thenResultTrue() {
        let str = "To the moon 🚀 ~!@#$%^&*()_+`[] \\ { } |"
        
        let result = str.contains([.emoji, .specialCharacter])
        
        XCTAssertTrue(result)
    }
    
    func test_contains_whenStringContainsSpecialCharacterAndNumber_thenResultTrue() {
        let str = "To the moon @# 12312"
        
        let result = str.contains([.specialCharacter, .number])
        
        XCTAssertTrue(result)
    }
    
}
