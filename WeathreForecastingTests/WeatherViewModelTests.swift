//
//  WeatherViewModelClass.swift
//  WeathreForecastingTests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import XCTest
import Combine
@testable import WeathreForecasting


class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockService: MockWeatherService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockService)
        cancellables = []
        
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather")
        let cityName = "DOHA"
        let mockWeatherResponse = createMockWeatherResponse(for: cityName)
        mockService.result = .success(mockWeatherResponse)
        viewModel.cityName = cityName
        
        // When
        viewModel.fetchWeather()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.currentWeather?.main.temp, 20)
            XCTAssertEqual(self.viewModel.forecast.count, 40)
            XCTAssertNil(self.viewModel.errorMessage)
            XCTAssertEqual(self.viewModel.cityName, cityName)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchWeatherFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather error")
        let mockError = NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockService.result = .failure(mockError)
        viewModel.cityName = "InvalidCity"
        
        // When
        viewModel.fetchWeather()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertNil(self.viewModel.currentWeather)
            XCTAssertTrue(self.viewModel.forecast.isEmpty)
            XCTAssertEqual(self.viewModel.errorMessage, "Failed to fetch weather: Test error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFormatTemperature() {
        // Given
        let kelvinTemp = 293.15 // 20°C
        
        // When
        let formattedTemp = viewModel.formatTemperature(kelvinTemp)
        
        // Then
        XCTAssertEqual(formattedTemp, "20.0°C")
    }
    
    func testFormatDate() {
        // Given
        let dateString = "2024-10-12 12:00:00"
        
        // When
        let formattedDate = viewModel.formatDate(dateString)
        
        // Then
        XCTAssertEqual(formattedDate, "Saturday, Oct 12")
    }
    
    //    func testGetDailyForecast() {
    //        // Given
    //        let cityName = "TestCity"
    //        let mockWeatherResponse = createMockWeatherResponse(for: cityName)
    //        mockService.result = .success(mockWeatherResponse)
    //
    //        let expectation = XCTestExpectation(description: "Fetch weather data")
    //        viewModel.cityName = cityName
    //
    //        print("Initial state:")
    //        print("cityName: \(viewModel.cityName)")
    //        print("forecast count: \(viewModel.forecast.count)")
    //
    //        // When
    //        viewModel.fetchWeather()
    //
    //        // Then
    //        viewModel.$forecast
    //            .dropFirst()
    //            .sink { [weak self] forecast in
    //                guard let self = self else { return }
    //
    //                print("After fetchWeather:")
    //                print("cityName: \(self.viewModel.cityName)")
    //                print("forecast count: \(forecast.count)")
    //
    //                let dailyForecast = self.viewModel.getDailyForecast()
    //
    //                print("dailyForecast count: \(dailyForecast.count)")
    //
    //                if dailyForecast.isEmpty {
    //                    print("Daily forecast is empty. Debug information:")
    //                    print("First item in forecast: \(forecast.first?.dtTxt ?? "N/A")")
    //                    print("Last item in forecast: \(forecast.last?.dtTxt ?? "N/A")")
    //                } else {
    //                    for (index, day) in dailyForecast.enumerated() {
    //                        print("Day \(index + 1): \(day.date), High: \(day.highTemperature), Low: \(day.lowTemperature), Condition: \(day.condition)")
    //                    }
    //                }
    //
    //
    //
    //                XCTAssertEqual(dailyForecast.count, 5, "Should have 5 days of forecast")
    //
    //                if dailyForecast.count == 5 {
    //                    // Check the first day's forecast
    //                    XCTAssertEqual(dailyForecast[0].highTemperature, 22)
    //                    XCTAssertEqual(dailyForecast[0].lowTemperature, 18)
    //                    XCTAssertEqual(dailyForecast[0].condition, "Clear")
    //
    //                    // Check if the dates are different for each forecast
    //                    let uniqueDates = Set(dailyForecast.map { $0.date })
    //                    XCTAssertEqual(uniqueDates.count, 5, "Each forecast should be for a different day")
    //
    //                    // Print out the daily forecasts for debugging
    //                    for (index, day) in dailyForecast.enumerated() {
    //                        print("Day \(index + 1): Date: \(day.date), High: \(day.highTemperature), Low: \(day.lowTemperature), Condition: \(day.condition)")
    //                    }
    //                } else {
    //                    // If we don't have 5 days, print out what we do have for debugging
    //                    for (index, day) in dailyForecast.enumerated() {
    //                        print("Day \(index + 1): Date: \(day.date), High: \(day.highTemperature), Low: \(day.lowTemperature), Condition: \(day.condition)")
    //                    }
    //                }
    //
    //                expectation.fulfill()
    //            }
    //            .store(in: &cancellables)
    //
    //        wait(for: [expectation], timeout: 1)
    //    }
    
    //    func testGetDailyForecast() {
    //            // Given
    //            let cityName = "TestCity"
    //            let mockWeatherResponse = createMockWeatherResponse(for: cityName)
    //            mockService.result = .success(mockWeatherResponse)
    //
    //            print("Mock weather response:")
    //            print("City: \(mockWeatherResponse.city.name)")
    //            print("Forecast count: \(mockWeatherResponse.list.count)")
    //            print("First forecast item: \(mockWeatherResponse.list.first?.dtTxt ?? "N/A")")
    //            print("Last forecast item: \(mockWeatherResponse.list.last?.dtTxt ?? "N/A")")
    //
    //            let expectation = XCTestExpectation(description: "Fetch weather data")
    //            viewModel.cityName = cityName
    //
    //            // When
    //            viewModel.fetchWeather()
    //
    //            // Then
    //            viewModel.$forecast
    //                .dropFirst()
    //                .sink { [weak self] forecast in
    //                    guard let self = self else { return }
    //
    //                    print("After fetchWeather:")
    //                    print("cityName: \(self.viewModel.cityName)")
    //                    print("forecast count: \(forecast.count)")
    //
    //                    let dailyForecast = self.viewModel.getDailyForecast()
    //
    //                    print("dailyForecast count: \(dailyForecast.count)")
    //
    //                    // ... rest of the test ...
    //
    //                    expectation.fulfill()
    //                }
    //                .store(in: &cancellables)
    //
    //            wait(for: [expectation], timeout: 1)
    //        }
    
    
    
    func testGetDailyForecast() {
        // Given
        let cityName = "TestCity"
        let mockWeatherResponse = createMockWeatherResponse(for: cityName)
        mockService.result = .success(mockWeatherResponse)
        
        print("Mock weather response:")
        print("City: \(mockWeatherResponse.city.name)")
        print("Forecast count: \(mockWeatherResponse.list.count)")
        
        let fetchExpectation = XCTestExpectation(description: "Fetch weather data")
        let forecastExpectation = XCTestExpectation(description: "Calculate daily forecast")
        
        viewModel.cityName = cityName
        
        // When
        viewModel.fetchWeather()
        
        // Then
        viewModel.$forecast
            .dropFirst() // Skip the initial empty value
            .filter { !$0.isEmpty } // Wait for non-empty forecast
            .first() // Take the first non-empty value
            .sink { [weak self] forecast in
                guard let self = self else { return }
                print("Forecast updated. Count: \(forecast.count)")
                fetchExpectation.fulfill()
                
                DispatchQueue.main.async {
                    let dailyForecast = self.viewModel.getDailyForecast()
                    print("Daily forecast calculated. Count: \(dailyForecast.count)")
                    
                    XCTAssertEqual(dailyForecast.count, 5, "Should have 5 days of forecast")
                    
                    if dailyForecast.count == 5 {
                        // Additional assertions
                        XCTAssertEqual(dailyForecast[0].condition, "Clear", "First day's condition should be Clear")
                        XCTAssertGreaterThanOrEqual(dailyForecast[0].highTemperature, dailyForecast[0].lowTemperature, "High temperature should be greater than or equal to low temperature")
                    }
                    
                    forecastExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [fetchExpectation, forecastExpectation], timeout: 5)
    }
    
    func testFiveDayForecast() {
        // Given
        let mockWeatherResponse = createMockWeatherResponse(for: "TestCity")
        mockService.result = .success(mockWeatherResponse)
        
        let fetchExpectation = XCTestExpectation(description: "Fetch weather data")
        let forecastExpectation = XCTestExpectation(description: "Calculate daily forecast")
        
        viewModel.cityName = "TestCity"
        
        // When
        viewModel.fetchWeather()
        
        // Then
        viewModel.$forecast
            .dropFirst()
            .filter { !$0.isEmpty }
            .first()
            .sink { [weak self] _ in
                guard let self = self else { return }
                fetchExpectation.fulfill()
                
                DispatchQueue.main.async {
                    let fiveDayForecast = self.viewModel.getDailyForecast()
                    
                    // Debug print
                    print("Number of forecast days: \(fiveDayForecast.count)")
                    for (index, forecast) in fiveDayForecast.enumerated() {
                        print("Day \(index + 1): Date: \(forecast.date), High: \(forecast.highTemperature), Low: \(forecast.lowTemperature), Condition: \(forecast.condition)")
                    }
                    
                    // Test 1: Check if we have exactly 5 days of forecast
                    XCTAssertEqual(fiveDayForecast.count, 5, "Should have exactly 5 days of forecast")
                    
                    // Test 2: Check if the dates are in ascending order and consecutive
                    let dates = fiveDayForecast.map { $0.date }
                    XCTAssertEqual(dates, dates.sorted(), "Dates should be in ascending order")
                    for i in 1..<dates.count {
                        XCTAssertEqual(Calendar.current.dateComponents([.day], from: dates[i-1], to: dates[i]).day, 1, "Dates should be consecutive")
                    }
                    
                    // Test 3: Check if each day's forecast has the correct properties
                    for dayForecast in fiveDayForecast {
                        XCTAssertFalse(dayForecast.condition.isEmpty, "Weather condition should not be empty")
                        XCTAssertGreaterThanOrEqual(dayForecast.highTemperature, dayForecast.lowTemperature, "High temperature should be greater than low temperature")
                        XCTAssertGreaterThanOrEqual(dayForecast.highTemperature, -50, "High temperature should be within a reasonable range")
                        XCTAssertLessThanOrEqual(dayForecast.highTemperature, 60, "High temperature should be within a reasonable range")
                        XCTAssertGreaterThanOrEqual(dayForecast.lowTemperature, -50, "Low temperature should be within a reasonable range")
                        XCTAssertLessThanOrEqual(dayForecast.lowTemperature, 60, "Low temperature should be within a reasonable range")
                    }
                    
                    // Test 4: Check if the first day's forecast matches our mock data
                    let firstDay = fiveDayForecast.first!
                    XCTAssertEqual(firstDay.highTemperature, 20, accuracy: 0.001, "First day's high temperature should match mock data")
                    XCTAssertEqual(firstDay.lowTemperature, 20, accuracy: 0.001, "First day's low temperature should match mock data")
                    XCTAssertEqual(firstDay.condition, "Clear", "First day's condition should match mock data")
                    
                    // Test 5: Check if we're using the most frequent condition for each day
                    for dayForecast in fiveDayForecast {
                        XCTAssertEqual(dayForecast.condition, "Clear", "Each day's condition should be the most frequent one from that day")
                    }
                    
                    forecastExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [fetchExpectation, forecastExpectation], timeout: 5)
        
    }
    
    
    private func createMockWeatherResponse(for cityName: String) -> WeatherResponse {
           let calendar = Calendar.current
           let now = Date()
           let weatherDataList = (0..<40).map { index -> WeatherData in
               let date = calendar.date(byAdding: .hour, value: index * 3, to: now)!
               return WeatherData(
                   dt: Int(date.timeIntervalSince1970),
                   main: MainWeather(temp: 20.0,
                                     feelsLike: 21.0,
                                     tempMin: 18.0,
                                     tempMax: 22.0,
                                     pressure: 1013,
                                     seaLevel: 1013,
                                     grndLevel: 1010,
                                     humidity: 65,
                                     tempKf: 0),
                   weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
                   clouds: Clouds(all: 0),
                   wind: Wind(speed: 3.5, deg: 120, gust: 5.0),
                   visibility: 10000,
                   pop: 0,
                   sys: Sys(pod: "d"),
                   dtTxt: ISO8601DateFormatter().string(from: date)
               )
           }
           
           return WeatherResponse(
               cod: "200",
               message: 0,
               cnt: 40,
               list: weatherDataList,
               city: City(id: 2643743, name: cityName, coord: Coord(lat: 51.5074, lon: -0.1278), country: "TS", population: 1000000, timezone: 0, sunrise: 1728699335, sunset: 1728741271)
           )
       }
    
}



extension WeatherViewModelTests {
    func testCachingFunctionality() {
        // Given
        let expectation = XCTestExpectation(description: "Cache weather data")
        let mockWeatherResponse = createMockWeatherResponse(for: "DOHA")
        mockService.result = .success(mockWeatherResponse)
        viewModel.cityName = "DOHA"
        
        // When
        viewModel.fetchWeather()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Simulate app restart by creating a new ViewModel
            let newViewModel = WeatherViewModel(weatherService: self.mockService)
            newViewModel.loadCachedWeatherData()
            
            XCTAssertEqual(newViewModel.cityName, "DOHA")
            XCTAssertEqual(newViewModel.currentWeather?.main.temp, 20.0)
            XCTAssertEqual(newViewModel.forecast.count, 40)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testTemperatureConversion() {
        // Given
        let kelvinTemps = [273.15, 293.15, 303.15, 313.15]
        let expectedCelsius = [0.0, 20.0, 30.0, 40.0]
        
        // When & Then
        for (kelvin, expectedCelsius) in zip(kelvinTemps, expectedCelsius) {
            let formattedTemp = viewModel.formatTemperature(kelvin)
            XCTAssertEqual(formattedTemp, "\(expectedCelsius)°C")
        }
    }
    
    func testDateFormatting() {
        // Given
        let dateStrings = [
            "2024-10-12 12:00:00",
            "2024-12-25 00:00:00",
            "2025-01-01 15:30:00",
            "2025-07-04 18:45:00"
        ]
        let expectedFormats = [
            "Saturday, Oct 12",
            "Wednesday, Dec 25",
            "Wednesday, Jan 1",
            "Friday, Jul 4"
        ]
        
        // When & Then
        for (dateString, expectedFormat) in zip(dateStrings, expectedFormats) {
            let formattedDate = viewModel.formatDate(dateString)
            XCTAssertEqual(formattedDate, expectedFormat)
        }
    }
    
    func testExtremeTemperatures() {
        // Given
        let extremeTemps = [
            173.15,  // -100°C
            223.15,  // -50°C
            323.15,  // 50°C
            373.15   // 100°C
        ]
        let expectedFormats = [
            "-100.0°C",
            "-50.0°C",
            "50.0°C",
            "100.0°C"
        ]
        
        // When & Then
        for (temp, expectedFormat) in zip(extremeTemps, expectedFormats) {
            let formattedTemp = viewModel.formatTemperature(temp)
            XCTAssertEqual(formattedTemp, expectedFormat)
        }
    }
}
