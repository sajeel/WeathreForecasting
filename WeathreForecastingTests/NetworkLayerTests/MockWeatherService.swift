//
//  MockWeatherService.swift
//  WeathreForecastingTests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import XCTest
import Combine
@testable import WeathreForecasting

class MockWeatherService: WeatherServiceProtocol {
    var result: Result<WeatherResponse, Error>?
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        guard let result = result else {
            fatalError("Result not set")
        }
        
        return result.publisher
            .delay(for: 0.1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}


