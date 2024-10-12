//
//  ContentView.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.cityName, onSearchButtonClicked: viewModel.fetchWeather)
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else if let currentWeather = viewModel.currentWeather {
                    CurrentWeatherView(currentWeather: currentWeather)
                    ForecastView(forecast: viewModel.forecast)
                } else {
                    Text("Enter a city name to see the weather forecast")
                }
            }
            .navigationTitle("Weather Forecast")
        }
        .onAppear {
            viewModel.loadCachedWeatherData()
        }
    }
}



#Preview {
    ContentView()
}
