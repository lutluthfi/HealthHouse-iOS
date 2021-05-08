//
//  XCTestCase+Evetually.swift
//  HealthHouseTests
//
//  Created by Arif Luthfiansyah on 31/03/21.
//

import XCTest

extension XCTestCase {
    
    /// Simple helper for asynchronous testing.
    ///
    /// ~~~
    ///   func testSomething() {
    ///       doAsyncThings()
    ///       eventually {
    ///           /* XCTAssert goes here... */
    ///       }
    ///   }
    /// ~~~
    ///
    /// Cloure won't execute until timeout is met. You need to pass in an
    /// timeout long enough for your asynchronous process to finish,
    /// if it's expected to take more than the default 0.01 second.
    ///
    /// - Parameters:
    ///   - timeoutAfter: amout of time in seconds to wait before executing the closure
    ///   - timeoutExpectation: amount of time in seconds to wait for the expectation
    ///   - closure: a closure to execute when `timeout` seconds has passed
    func eventually(timeoutAfter: TimeInterval = 0.01, timeoutExpectation: TimeInterval = 60,  closure: @escaping () -> Void) {
        let expectation = self.expectation(description: "")
        expectation.fulfillAfter(timeoutAfter)
        self.waitForExpectations(timeout: timeoutExpectation) { _ in
            closure()
        }
    }
}

extension XCTestExpectation {
    
    /// Call `fulfill()` after some time.
    ///
    /// - Parameter time: amout of time after which `fulfill()` will be called.
    func fulfillAfter(_ time: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.fulfill()
        }
    }
}
