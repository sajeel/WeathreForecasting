//
//  DailyForecastListTests.swift
//  WeathreForecastingUITests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import XCTest
//@testable import WeathreForecasting
//
//class DailyForecastListTests: XCTestCase {
//    
//    var viewModel: WeatherViewModel!
//    
//    override func setUp() {
//        super.setUp()
//        viewModel = WeatherViewModel()
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        super.tearDown()
//    }
//    
//    func testDailyForecastListData() {
//        // Given
//        let mockForecasts = createMockDailyForecasts()
//        viewModel.forecast = createMockWeatherData(from: mockForecasts)
//        
//        // When
//        let dailyForecasts = viewModel.getDailyForecast()
//        
//        // Then
//        XCTAssertEqual(dailyForecasts.count, mockForecasts.count, "Should have the correct number of daily forecasts")
//        
//        for (index, forecast) in dailyForecasts.enumerated() {
//            XCTAssertEqual(forecast.date, mockForecasts[index].date, "Date should match")
//            XCTAssertEqual(forecast.highTemperature, mockForecasts[index].highTemperature, accuracy: 0.01, "High temperature should match")
//            XCTAssertEqual(forecast.lowTemperature, mockForecasts[index].lowTemperature, accuracy: 0.01, "Low temperature should match")
//            XCTAssertEqual(forecast.condition, mockForecasts[index].condition, "Condition should match")
//        }
//    }
//    
//    func testDailyForecastListFormatting() {
//        // Given
//        let mockForecasts = createMockDailyForecasts()
//        viewModel.forecast = createMockWeatherData(from: mockForecasts)
//        
//        // When
//        let dailyForecasts = viewModel.getDailyForecast()
//        
//        // Then
//        for forecast in dailyForecasts {
//            let formattedDate = viewModel.formatDate(forecast.date.description)
//            XCTAssertFalse(formattedDate.isEmpty, "Formatted date should not be empty")
//            
//            let formattedHighTemp = viewModel.formatTemperature(forecast.highTemperature)
//            XCTAssertTrue(formattedHighTemp.contains("°C"), "Formatted high temperature should contain °C")
//            
//            let formattedLowTemp = viewModel.formatTemperature(forecast.lowTemperature)
//            XCTAssertTrue(formattedLowTemp.contains("°C"), "Formatted low temperature should contain °C")
//        }
//    }
//    
//    func testDailyForecastListWithEmptyData() {
//        // Given
//        viewModel.forecast = []
//        
//        // When
//        let dailyForecasts = viewModel.getDailyForecast()
//        
//        // Then
//        XCTAssertTrue(dailyForecasts.isEmpty, "Daily forecasts should be empty when there's no forecast data")
//    }
//    
//    // Helper methods
//    
//    private func createMockDailyForecasts() -> [DailyForecast] {
//        let calendar = Calendar.current
//        let now = Date()
//        return (0..<5).map { index in
//            let date = calendar.date(byAdding: .day, value: index, to: now)!
//            return DailyForecast(
//                date: date,
//                highTemperature: Double(20 + index),
//                lowTemperature: Double(10 + index),
//                condition: ["Sunny", "Cloudy", "Rainy", "Windy", "Snowy"][index]
//            )
//        }
//    }
//    
//    private func createMockWeatherData(from dailyForecasts: [DailyForecast]) -> [WeatherData] {
//        return dailyForecasts.flatMap { forecast in
//            (0..<8).map { hour in
//                let date = Calendar.current.date(byAdding: .hour, value: hour * 3, to: forecast.date)!
//                return WeatherData(
//                    dt: Int(date.timeIntervalSince1970),
//                    main: MainWeather(
//                        temp: Double.random(in: forecast.lowTemperature...forecast.highTemperature),
//                        feelsLike: Double.random(in: forecast.lowTemperature...forecast.highTemperature),
//                        tempMin: forecast.lowTemperature,
//                        tempMax: forecast.highTemperature,
//                        pressure: 1013,
//                        seaLevel: 1013,
//                        grndLevel: 1010,
//                        humidity: 65,
//                        tempKf: 0
//                    ),
//                    weather: [Weather(id: 800, main: forecast.condition, description: "description", icon: "icon")],
//                    clouds: Clouds(all: 0),
//                    wind: Wind(speed: 3.5, deg: 120, gust: 5.0),
//                    visibility: 10000,
//                    pop: 0,
//                    sys: Sys(pod: "d"),
//                    dtTxt: ISO8601DateFormatter().string(from: date)
//                )
//            }
//        }
//    }
//}
