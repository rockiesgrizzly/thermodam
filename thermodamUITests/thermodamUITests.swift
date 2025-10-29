//
//  thermodamUITests.swift
//  thermodamUITests
//
//  Created by Josh MacDonald on 10/21/25.
//

import XCTest

final class thermodamUITests: XCTestCase {

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
