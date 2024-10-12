//
//  WeatherService.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import Combine

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "your-api-key"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherData, Error> {
        let urlString = "\(baseURL)/forecast?q=\(city)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
