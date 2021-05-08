//
//  ArrayEquatableTests.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import XCTest
@testable import Health_House

class ArrayEquatableTests: XCTestCase {
    
    func test_insertElementAfterFirstIndexOf_whenArrayHasNotElement_thenElementInserted() {
        var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
        
        array.insert(10, afterFirstIndexOf: 2)
        
        XCTAssertEqual(array, [1, 2, 10, 3, 4, 5, 6, 7, 8, 9, 0])
    }
    
    func test_insertElementAfterFirstIndexOf_whenArrayHasElement_thenElementNotInserted() {
        var array = [1, 3, 4, 5, 6, 7, 8, 9, 0]
        
        array.insert(10, afterFirstIndexOf: 2)
        
        XCTAssertEqual(array, [1, 3, 4, 5, 6, 7, 8, 9, 0])
    }
    
    func test_insertElementBeforeFirstIndexOf_whenArrayHasNotElement_thenElementInserted() {
        var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
        
        array.insert(10, beforeFirstIndexOf: 2)
        
        XCTAssertEqual(array, [1, 10, 2, 3, 4, 5, 6, 7, 8, 9, 0])
    }
    
    func test_insertElementBeforeFirstIndexOf_whenArrayHasElement_thenElementNotInserted() {
        var array = [1, 3, 4, 5, 6, 7, 8, 9, 0]
        
        array.insert(10, beforeFirstIndexOf: 2)
        
        XCTAssertEqual(array, [1, 3, 4, 5, 6, 7, 8, 9, 0])
    }

    func test_removeFirstIndexOf_whenArrayHasElement_thenElementRemoved() {
        var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
        
        array.remove(firstIndexOf: 2)
        
        XCTAssertEqual(array, [1, 3, 4, 5, 6, 7, 8, 9, 0])
    }
    
    func test_removeFirstIndexOf_whenArrayHasNotElement_thenElementNotRemoved() {
        var array = [1, 3, 4, 5, 6, 7, 8, 9, 0]
        
        array.remove(firstIndexOf: 2)
        
        XCTAssertEqual(array, [1, 3, 4, 5, 6, 7, 8, 9, 0])
    }
    
    func test_indexOf_whenArrayHasElement_thenIndexNotNil() {
        let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
        
        let result = array.index(of: 5)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 4)
    }
    
    func test_indexOf_whenArrayHasNotElement_thenIndexNil() {
        let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
        
        let result = array.index(of: 10)
        
        XCTAssertNil(result)
    }

}
