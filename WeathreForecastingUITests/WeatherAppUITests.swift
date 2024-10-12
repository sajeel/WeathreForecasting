//
//  WeatherAppUITests.swift
//  WeathreForecastingUITests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import XCTest
@testable import WeathreForecasting

final class WeatherAppUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
//    func testDailyForecastListAppears() throws {
//            // Enter a city name
//            let cityNameTextField = app.textFields["Enter city name"]
//            cityNameTextField.tap()
//            cityNameTextField.typeText("DOHA")
//
//            // Tap the fetch weather button
//            let fetchWeatherButton = app.buttons["Fetch Weather"]
//            fetchWeatherButton.tap()
//
//            // Wait for the list to appear
//            let forecastList = app.tables["DailyForecastList"]
//            XCTAssertTrue(forecastList.waitForExistence(timeout: 30), "Forecast list should appear")
//
//            // Check if we have at least one row (we can't be sure of exact count in a real API call)
//            XCTAssertGreaterThan(forecastList.cells.count, 0, "Should display at least one day of forecast")
//
//            // Check the content of the first row
//            let firstRow = forecastList.cells.element(boundBy: 0)
//            XCTAssertTrue(firstRow.staticTexts["Date"].exists, "Date should be visible")
//            XCTAssertTrue(firstRow.staticTexts["HighTemp"].exists, "High temperature should be visible")
//            XCTAssertTrue(firstRow.staticTexts["LowTemp"].exists, "Low temperature should be visible")
//            XCTAssertTrue(firstRow.staticTexts["Condition"].exists, "Weather condition should be visible")
//        }

//        func testDailyForecastListScrolling() throws {
//            // First, make sure the list appears
//            try testDailyForecastListAppears()
//
//            let forecastList = app.tables["DailyForecastList"]
//
//            // Attempt to scroll to the bottom of the list
//            forecastList.swipeUp()
//
//            // Verify that we can scroll back to the top
//            forecastList.swipeDown()
//
//            // Verify that the first cell is now visible
//            XCTAssertTrue(forecastList.cells.element(boundBy: 0).isHittable, "Should be able to scroll back to the first forecast day")
//        }
    
    
    
    func testSearchFunctionality() {
        // Given
        let searchField = app.textFields["Enter city name"]
        let searchButton = app.buttons["Search"]
        
        // When
        searchField.tap()
        searchField.typeText("DOHA")
        searchButton.tap()
        
        // Then
        let cityNameLabel = app.staticTexts["DOHA"]
        XCTAssertTrue(cityNameLabel.waitForExistence(timeout: 5))
        
        let temperatureLabel = app.staticTexts.element(matching: .any, identifier: "TemperatureLabel")
        XCTAssertTrue(temperatureLabel.waitForExistence(timeout: 5))
    }
    
    func testNavigationToFiveDayForecast() {
        // Given
        let searchField = app.textFields["Enter city name"]
        let searchButton = app.buttons["Search"]
        
        // When
        searchField.tap()
        searchField.typeText("DOHA")
        searchButton.tap()
        
        let fiveDayForecastButton = app.buttons["Five Day Forecast"]
        XCTAssertTrue(fiveDayForecastButton.waitForExistence(timeout: 5))
        fiveDayForecastButton.tap()
        
        // Then
        let navigationBar = app.navigationBars["5-Day Forecast"]
        XCTAssertTrue(navigationBar.exists)
        
        let forecastList = app.tables.firstMatch
        XCTAssertTrue(forecastList.exists)
        XCTAssertGreaterThan(forecastList.cells.count, 0)
    }
    
//    func testErrorMessageDisplay() {
//        // Given
//        let searchField = app.textFields["Enter city name"]
//        let searchButton = app.buttons["Search"]
//        
//        // When
//        searchField.tap()
//        searchField.typeText("InvalidCityName123456789")
//        searchButton.tap()
//        
//        // Then
//        let errorMessage = app.staticTexts.element(matching: .any, identifier: "ErrorMessage")
//        XCTAssertTrue(errorMessage.waitForExistence(timeout: 15))
//    }
    
//    func testErrorMessageDisplay() {
//           let searchField = app.textFields["Enter city name"]
//           let searchButton = app.buttons["Search"]
//           
//           searchField.tap()
//           searchField.typeText("InvalidCityName123456789")
//           searchButton.tap()
//           
//           let errorMessage = app.staticTexts["ErrorMessage"]
//           
//           XCTAssertTrue(errorMessage.waitForExistence(timeout: 10), "Error message should appear for invalid city")
//           XCTAssertTrue(errorMessage.label.contains("Failed to fetch weather"), "Error message should indicate failure to fetch weather")
//       }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
