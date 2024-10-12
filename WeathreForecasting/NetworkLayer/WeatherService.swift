//
//  WeatherService.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import Combine
import Network




class WeatherService: WeatherServiceProtocol {
    private let apiKey: String
    private let baseURL: String
    private let session: URLSessionType
    public var networkMonitor: NetworkMonitoringProtocol
    private let timeout: TimeInterval
    
    init(apiKey: String = "bd5e378503939ddaee76f12ad7a97608",
         baseURL: String = "https://api.openweathermap.org/data/2.5",
         session: URLSessionType = URLSession.shared,
         timeout: TimeInterval = 10,
         networkMonitor: NetworkMonitoringProtocol = RealNetworkMonitor()) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.session = session
        self.timeout = timeout
        self.networkMonitor = networkMonitor
        startMonitoringNetwork()
    }
    
    private func startMonitoringNetwork() {
        networkMonitor.startMonitoring()
    }
    
    deinit {
        networkMonitor.stopMonitoring()
    }
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        guard networkMonitor.isConnected else {
            return Fail(error: URLError(.notConnectedToInternet)).eraseToAnyPublisher()
        }
        
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(baseURL)/forecast?q=\(encodedCity)&appid=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.publisherForDataTask(with: url)
            .timeout(.seconds(timeout), scheduler: DispatchQueue.main)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .mapError { error in
                if let urlError = error as? URLError {
                    return urlError
                } else if error is DecodingError {
                    return URLError(.cannotDecodeContentData)
                } else {
                    return URLError(.unknown)
                }
            }
            .eraseToAnyPublisher()
    }
}
