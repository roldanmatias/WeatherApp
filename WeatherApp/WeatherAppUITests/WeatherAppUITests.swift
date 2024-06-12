//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Matias Roldan on 10/06/2024.
//

import XCTest

final class WeatherAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testHomeScreenElements() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(XCUIApplication().staticTexts["cityLabel"].waitForExistence(timeout: 3))
        XCTAssertTrue(XCUIApplication().staticTexts["temperatureLabel"].exists)
        XCTAssertTrue(XCUIApplication().staticTexts["descriptionLabel"].exists)
        XCTAssertTrue(XCUIApplication().staticTexts["lowHighLabel"].exists)
        XCTAssertTrue(XCUIApplication().staticTexts["windLabel"].exists)
        XCTAssertTrue(XCUIApplication().images["iconImageView"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
