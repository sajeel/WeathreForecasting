//
//  ForecastView.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI
 
struct ForecastView: View {
    let forecast: [WeatherData]
    let viewModel: WeatherViewModel
    
    var body: some View {
        List(forecast) { weather in
            HStack {
                Text(viewModel.formatDate(weather.dtTxt))
                Spacer()
                Text(viewModel.formatTemperature(weather.main.temp))
                Text(weather.weather.first?.main ?? "")
            }
        }
    }
}
 
