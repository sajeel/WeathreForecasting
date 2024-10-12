//
//  CurrentWeatherView.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI

struct CurrentWeatherView: View {
    let currentWeather: CurrentWeather
    
    var body: some View {
        VStack {
            Text("\(Int(currentWeather.temperature))°C")
                .font(.largeTitle)
            Text(currentWeather.description)
                .font(.title2)
            HStack {
                Text("Humidity: \(currentWeather.humidity)%")
                Text("Wind: \(Int(currentWeather.windSpeed)) km/h")
            }
        }
        .padding()
    }
}

 
