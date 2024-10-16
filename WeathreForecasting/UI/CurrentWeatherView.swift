//
//  CurrentWeatherView.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI


struct CurrentWeatherView: View {
    let weatherData: WeatherData
    let viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.cityName)
                .font(.title)
            
            Text(viewModel.formatTemperature(weatherData.main.temp))
                .font(.largeTitle)
            
            Text(weatherData.weather.first?.description.capitalized ?? "")
                .font(.title2)
            
            HStack {
                Label("Humidity: \(weatherData.main.humidity)%", systemImage: "humidity")
                Spacer()
                Label("Wind: \(Int(weatherData.wind.speed)) m/s", systemImage: "wind")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

