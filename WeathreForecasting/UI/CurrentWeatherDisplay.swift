//
//  CurrentWeatherDisplay.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI

struct CurrentWeatherDisplay: View {
    let weatherData: WeatherData
    let viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.cityName)
                .font(.title)
            Text(viewModel.formatTemperature(weatherData.main.temp))
                .font(.largeTitle)
            Text(weatherData.weather.first?.description.capitalized ?? "")
                .font(.title2)
            HStack {
                Text("Humidity: \(weatherData.main.humidity)%")
                Text("Wind: \(Int(weatherData.wind.speed)) m/s")
            }
        }
        .padding()
    }
}
