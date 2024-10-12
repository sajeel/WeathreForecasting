//
//  WeatherViewModel.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import Combine


// MARK: - ViewModels

//class WeatherViewModel: ObservableObject {
//    @Published var currentWeather: WeatherData?
//    @Published var forecast: [WeatherData] = []
//    @Published var cityName: String = ""
//    @Published var errorMessage: String?
//    @Published var isLoading = false
//
//    private let weatherService: WeatherServiceProtocol
//    private var cancellables = Set<AnyCancellable>()
//
//    init(weatherService: WeatherServiceProtocol = WeatherService()) {
//        self.weatherService = weatherService
//    }
//
//    func fetchWeather() {
//        guard !cityName.isEmpty else { return }
//
//        isLoading = true
//        errorMessage = nil
//
//        weatherService.fetchWeather(for: cityName)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                if case .failure(let error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            } receiveValue: { [weak self] weatherResponse in
//                self?.currentWeather = weatherResponse.list.first
//                self?.forecast = Array(weatherResponse.list.prefix(40)) // Keep all 5 days of forecast data
//                self?.cityName = weatherResponse.city.name
//                self?.cacheWeatherData(weatherResponse)
//            }
//            .store(in: &cancellables)
//    }
//
//    private func cacheWeatherData(_ data: WeatherResponse) {
//        // Implement caching logic here
//    }
//
//    func loadCachedWeatherData() {
//        // Implement loading cached data here
//    }
//
//    func formatTemperature(_ temperature: Double) -> String {
//        let celsius = temperature - 273.15 // Convert Kelvin to Celsius
//        return String(format: "%.1f°C", celsius)
//    }
//
//    func formatDate(_ dateString: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        guard let date = dateFormatter.date(from: dateString) else { return dateString }
//
//        dateFormatter.dateFormat = "EEEE, MMM d"
//        return dateFormatter.string(from: date)
//    }
//
//    func getDailyForecast() -> [DailyForecast] {
//        let groupedForecast = Dictionary(grouping: forecast) { weatherData -> Date in
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            guard let date = dateFormatter.date(from: weatherData.dtTxt) else { return Date() }
//            return Calendar.current.startOfDay(for: date)
//        }
//
//        return groupedForecast.sorted(by: { $0.key < $1.key }).map { (date, weatherDataArray) in
//            let temperatures = weatherDataArray.map { $0.main.temp }
//            let highTemp = temperatures.max() ?? 0
//            let lowTemp = temperatures.min() ?? 0
//            let conditions = weatherDataArray.compactMap { $0.weather.first?.main }
//            let mostCommonCondition = conditions.mostCommon
//
//            return DailyForecast(date: date, highTemperature: highTemp, lowTemperature: lowTemp, condition: mostCommonCondition ?? "Unknown")
//        }
//    }
//}


class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherData?
    @Published var forecast: [WeatherData] = []
//    @Published private(set) var forecast: [WeatherData] = []

    @Published var cityName: String = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let weatherService: WeatherServiceProtocol
    private let cacheManager: CacheManager
    private var cancellables = Set<AnyCancellable>()
    
    private let weatherCacheKey = "cachedWeatherData"
    private let cityCacheKey = "cachedCity"
    
    init(weatherService: WeatherServiceProtocol = WeatherService(), cacheManager: CacheManager = .shared) {
        self.weatherService = weatherService
        self.cacheManager = cacheManager
    }
    
    func fetchWeather() {
        guard !cityName.isEmpty else {
            self.errorMessage = "Please enter a city name"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        weatherService.fetchWeather(for: cityName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] weatherResponse in
                self?.currentWeather = weatherResponse.list.first
//                self?.forecast = Array(weatherResponse.list.prefix(40))
                self?.cityName = weatherResponse.city.name
                self?.forecast = weatherResponse.list
                self?.cacheWeatherData(weatherResponse)
            }
            .store(in: &cancellables)
    }
    
    private func cacheWeatherData(_ data: WeatherResponse) {
        cacheManager.cache(data, forKey: weatherCacheKey)
        cacheManager.cache(cityName, forKey: cityCacheKey)
        cacheManager.cacheLastUpdated(forKey: weatherCacheKey)
    }
    
    func loadCachedWeatherData() {
        guard let cachedCity: String = cacheManager.retrieve(String.self, forKey: cityCacheKey),
              let weatherResponse: WeatherResponse = cacheManager.retrieve(WeatherResponse.self, forKey: weatherCacheKey) else {
            return
        }
        
        self.cityName = cachedCity
        self.currentWeather = weatherResponse.list.first
        self.forecast = Array(weatherResponse.list.prefix(40))
    }
    
    func clearCache() {
        cacheManager.remove(forKey: weatherCacheKey)
        cacheManager.remove(forKey: cityCacheKey)
    }
    
    func isCacheValid() -> Bool {
        guard let lastUpdated = cacheManager.lastUpdated(forKey: weatherCacheKey) else {
            return false
        }
        let cacheValidityDuration: TimeInterval = 30 * 60 // 30 minutes
        return Date().timeIntervalSince(lastUpdated) < cacheValidityDuration
    }
    
    
    func formatTemperature(_ temperature: Double) -> String {
        let celsius = temperature - 273.15 // Convert Kelvin to Celsius
        return String(format: "%.1f°C", celsius)
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: date)
    }
    
    
    func getDailyForecast() -> [DailyForecast] {
            print("getDailyForecast called on thread: \(Thread.current.isMainThread ? "Main" : "Background")")
            print("Current forecast count: \(forecast.count)")
            
            let calendar = Calendar.current
            let groupedForecast = Dictionary(grouping: forecast) { weatherData -> Date in
                let date = Date(timeIntervalSince1970: TimeInterval(weatherData.dt))
                return calendar.startOfDay(for: date)
            }
            
            print("Grouped forecast count: \(groupedForecast.count)")
            
            let sortedForecast = groupedForecast.sorted(by: { $0.key < $1.key })
            print("Sorted forecast count: \(sortedForecast.count)")
            
            let dailyForecasts = sortedForecast.prefix(5).map { (date, weatherDataArray) in
                let temperatures = weatherDataArray.map { $0.main.temp }
                let highTemp = temperatures.max() ?? 0
                let lowTemp = temperatures.min() ?? 0
                let conditions = weatherDataArray.compactMap { $0.weather.first?.main }
                let mostCommonCondition = conditions.mostCommon ?? "Unknown"
                
                return DailyForecast(date: date, highTemperature: highTemp, lowTemperature: lowTemp, condition: mostCommonCondition)
            }
            
            print("Final daily forecasts count: \(dailyForecasts.count)")
            return dailyForecasts
        }
    
    
//    func getDailyForecast() -> [DailyForecast] {
//        print("getDailyForecast called")
//        print("Current forecast count: \(forecast.count)")
//        
//        let calendar = Calendar.current
//        let groupedForecast = Dictionary(grouping: forecast) { weatherData -> Date in
//            let date = Date(timeIntervalSince1970: TimeInterval(weatherData.dt))
//            let startOfDay = calendar.startOfDay(for: date)
//            print("Grouping date: \(date), Start of day: \(startOfDay)")
//            return startOfDay
//        }
//        
//        print("Grouped forecast count: \(groupedForecast.count)")
//        
//        let sortedForecast = groupedForecast.sorted(by: { $0.key < $1.key })
//        print("Sorted forecast count: \(sortedForecast.count)")
//        
//        let dailyForecasts = sortedForecast.prefix(5).map { (date, weatherDataArray) in
//            let temperatures = weatherDataArray.map { $0.main.temp }
//            let highTemp = temperatures.max() ?? 0
//            let lowTemp = temperatures.min() ?? 0
//            let conditions = weatherDataArray.compactMap { $0.weather.first?.main }
//            let mostCommonCondition = conditions.mostCommon ?? "Unknown"
//            
//            print("Creating DailyForecast for date: \(date), High: \(highTemp), Low: \(lowTemp), Condition: \(mostCommonCondition)")
//            
//            return DailyForecast(date: date, highTemperature: highTemp, lowTemperature: lowTemp, condition: mostCommonCondition)
//        }
//        
//        print("Final daily forecasts count: \(dailyForecasts.count)")
//        return dailyForecasts
//    }
//    
    
    
    
    //    func getDailyForecast() -> [DailyForecast] {
    //        let groupedForecast = Dictionary(grouping: forecast) { weatherData -> Date in
    //            let dateFormatter = DateFormatter()
    //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //            guard let date = dateFormatter.date(from: weatherData.dtTxt) else { return Date() }
    //            return Calendar.current.startOfDay(for: date)
    //        }
    //
    //        return groupedForecast.sorted(by: { $0.key < $1.key }).prefix(5).map { (date, weatherDataArray) in
    //            let temperatures = weatherDataArray.map { $0.main.temp }
    //            let highTemp = temperatures.max() ?? 0
    //            let lowTemp = temperatures.min() ?? 0
    //            let conditions = weatherDataArray.compactMap { $0.weather.first?.main }
    //            let mostCommonCondition = conditions.mostCommon
    //
    //            return DailyForecast(date: date, highTemperature: highTemp, lowTemperature: lowTemp, condition: mostCommonCondition ?? "Unknown")
    //        }
    //    }
}
