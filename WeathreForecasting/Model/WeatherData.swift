//
//  WeatherData.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
 // MARK: - Models


struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let dt: Int
    let main: MainWeather
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
    
    init(dt: Int, main: MainWeather, weather: [Weather], clouds: Clouds, wind: Wind, visibility: Int, pop: Double, sys: Sys, dtTxt: String) {
        self.dt = dt
        self.main = main
        self.weather = weather
        self.clouds = clouds
        self.wind = wind
        self.visibility = visibility
        self.pop = pop
        self.sys = sys
        self.dtTxt = dtTxt
    }
        
}
