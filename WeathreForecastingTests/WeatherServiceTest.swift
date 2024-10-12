//
//  WeatherServiceTest.swift
//  WeathreForecastingTests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import XCTest
import Combine
@testable import WeathreForecasting

class WeatherServiceTests: XCTestCase {
    
    var weatherService: WeatherService!
    var mockURLSession: MockURLSession!
    var mockNetworkMonitor: MockNetworkMonitor!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        mockNetworkMonitor = MockNetworkMonitor()
        cancellables = []
    }
    
    override func tearDown() {
        weatherService = nil
        mockURLSession = nil
        mockNetworkMonitor = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather successfully")
        let cityName = "DOHA"
        let jsonResponse = """
            {
                "cod": "200",
                "message": 0,
                "cnt": 40,
                "list": [{
                    "dt": 1618317040,
                    "main": {
                        "temp": 284.07,
                        "feels_like": 282.84,
                        "temp_min": 284.07,
                        "temp_max": 284.07,
                        "pressure": 1019,
                        "sea_level": 1019,
                        "grnd_level": 1015,
                        "humidity": 62,
                        "temp_kf": 0
                    },
                    "weather": [{
                        "id": 500,
                        "main": "Rain",
                        "description": "light rain",
                        "icon": "10d"
                    }],
                    "clouds": {"all": 75},
                    "wind": {"speed": 3.6, "deg": 320},
                    "visibility": 10000,
                    "pop": 0.2,
                    "sys": {"pod": "d"},
                    "dt_txt": "2021-04-13 15:00:00"
                }],
                "city": {
                    "id": 2643743,
                    "name": "DOHA",
                    "coord": {"lat": 51.5085, "lon": -0.1257},
                    "country": "GB",
                    "population": 1000000,
                    "timezone": 3600,
                    "sunrise": 1618289443,
                    "sunset": 1618338526
                }
            }
            """
        mockURLSession.data = jsonResponse.data(using: .utf8)
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        weatherService = WeatherService(session: mockURLSession, networkMonitor: mockNetworkMonitor)
        
        // When
        weatherService.fetchWeather(for: cityName)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Expected successful weather fetch, but got error: \(error)")
                }
                expectation.fulfill()
            } receiveValue: { weatherResponse in
                // Then
                XCTAssertEqual(weatherResponse.city.name, "DOHA")
                XCTAssertEqual(weatherResponse.list.count, 1)
                XCTAssertEqual(weatherResponse.list.first?.main.temp, 284.07)
                XCTAssertEqual(weatherResponse.list.first?.weather.first?.description, "light rain")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchWeatherInvalidCity() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather for invalid city")
        let invalidCityName = "InvalidCityName123456789"
        
        mockURLSession.data = "Not Found".data(using: .utf8)
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        weatherService = WeatherService(session: mockURLSession, networkMonitor: mockNetworkMonitor)
        
        // When
        weatherService.fetchWeather(for: invalidCityName)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected failure for invalid city, but request finished successfully")
                case .failure(let error):
                    // Then
                    XCTAssertNotNil(error)
                    if let urlError = error as? URLError {
                        XCTAssertEqual(urlError.code, .badServerResponse)
                    } else {
                        XCTFail("Expected URLError, but got different error type")
                    }
                }
                expectation.fulfill()
            } receiveValue: { _ in
                XCTFail("Expected failure for invalid city, but received weather data")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchWeatherTimeout() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather with timeout")
        let cityName = "DOHA"
        
        mockURLSession.error = URLError(.timedOut)
        
        weatherService = WeatherService(session: mockURLSession, timeout: 5.0, networkMonitor: mockNetworkMonitor)
        
        // When
        weatherService.fetchWeather(for: cityName)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected timeout error, but request finished successfully")
                case .failure(let error):
                    // Then
                    XCTAssertNotNil(error)
                    if let urlError = error as? URLError {
                        XCTAssertEqual(urlError.code, .timedOut)
                    } else {
                        XCTFail("Expected URLError.timedOut, but got different error type")
                    }
                }
                expectation.fulfill()
            } receiveValue: { _ in
                XCTFail("Expected timeout error, but received weather data")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchWeatherNoInternet() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather with no internet")
        let cityName = "New York"
        
        mockNetworkMonitor.isConnected = false
        weatherService = WeatherService(session: mockURLSession, networkMonitor: mockNetworkMonitor)
        
        // When
        weatherService.fetchWeather(for: cityName)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected no internet error, but request finished successfully")
                case .failure(let error):
                    // Then
                    XCTAssertNotNil(error)
                    if let urlError = error as? URLError {
                        XCTAssertEqual(urlError.code, .notConnectedToInternet)
                    } else {
                        XCTFail("Expected URLError.notConnectedToInternet, but got different error type")
                    }
                }
                expectation.fulfill()
            } receiveValue: { _ in
                XCTFail("Expected no internet error, but received weather data")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}

//    var weatherService: WeatherService!
//    var mockURLSession: MockURLSession!
//    var mockNetworkMonitor: MockNetworkMonitor!
//    var cancellables: Set<AnyCancellable>!
//
//    override func setUp() {
//        super.setUp()
//        mockURLSession = MockURLSession()
//        mockNetworkMonitor = MockNetworkMonitor()
//        cancellables = []
//    }
//
//    override func tearDown() {
//        weatherService = nil
//        mockURLSession = nil
//        mockNetworkMonitor = nil
//        cancellables = nil
//        super.tearDown()
//    }
//
//    func testFetchWeatherSuccess() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather successfully")
//        let cityName = "DOHA"
//        let jsonResponse = """
//        {
//            "cod": "200",
//            "message": 0,
//            "cnt": 40,
//            "list": [{
//                "dt": 1618317040,
//                "main": {
//                    "temp": 284.07,
//                    "feels_like": 282.84,
//                    "temp_min": 284.07,
//                    "temp_max": 284.07,
//                    "pressure": 1019,
//                    "sea_level": 1019,
//                    "grnd_level": 1015,
//                    "humidity": 62,
//                    "temp_kf": 0
//                },
//                "weather": [{
//                    "id": 500,
//                    "main": "Rain",
//                    "description": "light rain",
//                    "icon": "10d"
//                }],
//                "clouds": {"all": 75},
//                "wind": {"speed": 3.6, "deg": 320},
//                "visibility": 10000,
//                "pop": 0.2,
//                "sys": {"pod": "d"},
//                "dt_txt": "2021-04-13 15:00:00"
//            }],
//            "city": {
//                "id": 2643743,
//                "name": "DOHA",
//                "coord": {"lat": 51.5085, "lon": -0.1257},
//                "country": "GB",
//                "population": 1000000,
//                "timezone": 3600,
//                "sunrise": 1618289443,
//                "sunset": 1618338526
//            }
//        }
//        """
//        mockURLSession.data = jsonResponse.data(using: .utf8)
//        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//
//        weatherService = WeatherService(session: mockURLSession, networkMonitor: mockNetworkMonitor)
//
//        // When
//        weatherService.fetchWeather(for: cityName)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    XCTFail("Expected successful weather fetch, but got error: \(error)")
//                }
//                expectation.fulfill()
//            } receiveValue: { weatherResponse in
//                // Then
//                XCTAssertEqual(weatherResponse.city.name, "DOHA")
//                XCTAssertEqual(weatherResponse.list.count, 1)
//                XCTAssertEqual(weatherResponse.list.first?.main.temp, 284.07)
//                XCTAssertEqual(weatherResponse.list.first?.weather.first?.description, "light rain")
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 1)
//    }
//
//    func testFetchWeatherInvalidCity() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather for invalid city")
//        let invalidCityName = "InvalidCityName123456789"
//
//        mockURLSession.data = nil
//        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://api.example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
//        mockURLSession.error = nil
//
//        weatherService = WeatherService(session: mockURLSession, networkMonitor: mockNetworkMonitor)
//
//        // When
//        weatherService.fetchWeather(for: invalidCityName)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    XCTFail("Expected failure for invalid city, but request finished successfully")
//                case .failure(let error):
//                    // Then
//                    XCTAssertNotNil(error)
//                    if let urlError = error as? URLError {
//                        XCTAssertEqual(urlError.code, .badServerResponse)
//                    } else {
//                        XCTFail("Expected URLError, but got different error type")
//                    }
//                }
//                expectation.fulfill()
//            } receiveValue: { _ in
//                XCTFail("Expected failure for invalid city, but received weather data")
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 1)
//    }
//
//    func testFetchWeatherTimeout() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather with timeout")
//        let cityName = "DOHA"
//
//        mockURLSession.error = URLError(.timedOut)
//
//        weatherService = WeatherService(session: mockURLSession, networkMonitor: mockNetworkMonitor, timeout: 0.01)
//
//        // When
//        weatherService.fetchWeather(for: cityName)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    XCTFail("Expected timeout error, but request finished successfully")
//                case .failure(let error):
//                    // Then
//                    XCTAssertNotNil(error)
//                    if let urlError = error as? URLError {
//                        XCTAssertEqual(urlError.code, .timedOut)
//                    } else {
//                        XCTFail("Expected URLError.timedOut, but got different error type")
//                    }
//                }
//                expectation.fulfill()
//            } receiveValue: { _ in
//                XCTFail("Expected timeout error, but received weather data")
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 1)
//    }
//
//    func testFetchWeatherNoInternet() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather with no internet")
//        let cityName = "New York"
//
//        mockNetworkMonitor.isConnected = false
//        weatherService = WeatherService(session: mockURLSession, networkMonitor: mockNetworkMonitor)
//
//        // When
//        weatherService.fetchWeather(for: cityName)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    XCTFail("Expected no internet error, but request finished successfully")
//                case .failure(let error):
//                    // Then
//                    XCTAssertNotNil(error)
//                    if let urlError = error as? URLError {
//                        XCTAssertEqual(urlError.code, .notConnectedToInternet)
//                    } else {
//                        XCTFail("Expected URLError.notConnectedToInternet, but got different error type")
//                    }
//                }
//                expectation.fulfill()
//            } receiveValue: { _ in
//                XCTFail("Expected no internet error, but received weather data")
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 1)
//    }
//






























//class WeatherServiceTests: XCTestCase {
//    var weatherService: WeatherService!
//    var cancellables: Set<AnyCancellable>!
//
//    override func setUp() {
//        super.setUp()
//        weatherService = WeatherService()
//        cancellables = []
//    }
//
//    override func tearDown() {
//        weatherService = nil
//        cancellables = nil
//        super.tearDown()
//    }
//
//    func testFetchWeatherSuccess() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather data successfully")
//        let cityName = "DOHA"
//
//        // When
//        weatherService.fetchWeather(for: cityName)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    XCTFail("Expected successful weather fetch, but got error: \(error)")
//                }
//                expectation.fulfill()
//            } receiveValue: { weatherResponse in
//                // Then
//                XCTAssertEqual(weatherResponse.city.name.lowercased(), cityName.lowercased())
//                XCTAssertFalse(weatherResponse.list.isEmpty)
//                XCTAssertNotNil(weatherResponse.list.first?.main.temp)
//                XCTAssertNotNil(weatherResponse.list.first?.weather.first?.description)
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 10)
//    }
//
//    func testFetchWeatherInvalidCity() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather for invalid city")
//        let invalidCityName = "InvalidCityName123456789"
//
//        // When
//        weatherService.fetchWeather(for: invalidCityName)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    XCTFail("Expected failure for invalid city, but request finished successfully")
//                case .failure(let error):
//                    // Then
//                    XCTAssertNotNil(error)
//                    if let urlError = error as? URLError {
//                        XCTAssertEqual(urlError.code, .badServerResponse)
//                    } else {
//                        XCTFail("Expected URLError, but got different error type")
//                    }
//                }
//                expectation.fulfill()
//            } receiveValue: { _ in
//                XCTFail("Expected failure for invalid city, but received weather data")
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 10)
//    }
//
//
//
//
//
//
//
//
//
//    func testFetchWeatherEmptyCity() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather for empty city name")
//        let emptyCity = ""
//
//        // When
//        weatherService.fetchWeather(for: emptyCity)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    XCTFail("Expected failure for empty city name, but request finished successfully")
//                case .failure(let error):
//                    // Then
//                    XCTAssertNotNil(error)
//                    if let urlError = error as? URLError {
//                        XCTAssertEqual(urlError.code, .badURL)
//                    } else {
//                        XCTFail("Expected URLError, but got different error type")
//                    }
//                }
//                expectation.fulfill()
//            } receiveValue: { _ in
//                XCTFail("Expected failure for empty city name, but received weather data")
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 10)
//    }
//
//    func testFetchWeatherNoInternet() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather with no internet")
//        let cityName = "New York"
//
//        weatherService = WeatherService()
//        weatherService.networkMonitor = MockNetworkMonitor()
//
//        // When
//        weatherService.fetchWeather(for: cityName)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    XCTFail("Expected no internet error, but request finished successfully")
//                case .failure(let error):
//                    // Then
//                    XCTAssertNotNil(error)
//                    if let urlError = error as? URLError {
//                        XCTAssertEqual(urlError.code, .notConnectedToInternet)
//                    } else {
//                        XCTFail("Expected URLError.notConnectedToInternet, but got different error type")
//                    }
//                }
//                expectation.fulfill()
//            } receiveValue: { _ in
//                XCTFail("Expected no internet error, but received weather data")
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 1)
//    }
//
//    func testFetchWeatherTimeout() {
//        // Given
//        let expectation = XCTestExpectation(description: "Fetch weather with timeout")
//        let cityName = "DOHA"
//
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 0.01 // Very short timeout for testing
//        let session = URLSession(configuration: configuration)
//
//        weatherService = WeatherService(session: session, timeout: 0.01)
//
//        // When
//        weatherService.fetchWeather(for: cityName)
//            .sink { completion in
//                switch completion {
//                case .finished:
//                    XCTFail("Expected timeout error, but request finished successfully")
//                case .failure(let error):
//                    // Then
//                    XCTAssertNotNil(error)
//                    if let urlError = error as? URLError {
//                        XCTAssertEqual(urlError.code, .timedOut)
//                    } else {
//                        XCTFail("Expected URLError.timedOut, but got different error type")
//                    }
//                }
//                expectation.fulfill()
//            } receiveValue: { _ in
//                XCTFail("Expected timeout error, but received weather data")
//            }
//            .store(in: &cancellables)
//
//        wait(for: [expectation], timeout: 1)
//    }
//}
