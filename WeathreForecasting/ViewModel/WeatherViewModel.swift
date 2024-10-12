//
//  WeatherViewModel.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import Combine

// MARK: - ViewModels

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var forecast: [DailyForecast] = []
    @Published var cityName: String = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    func fetchWeather() {
        guard !cityName.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        weatherService.fetchWeather(for: cityName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] weatherData in
                self?.currentWeather = weatherData.current
                self?.forecast = weatherData.forecast.daily
                self?.cacheWeatherData(weatherData)
            }
            .store(in: &cancellables)
    }
    
    private func cacheWeatherData(_ data: WeatherData) {
        // Implement caching logic here
    }
    
    func loadCachedWeatherData() {
        // Implement loading cached data here
    }
}
