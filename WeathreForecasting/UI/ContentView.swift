//
//  ContentView.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI

//struct ContentView: View {
//    @StateObject private var viewModel = WeatherViewModel()
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                SearchBar(text: $viewModel.cityName, onSearchButtonClicked: viewModel.fetchWeather)
//                
//                if viewModel.isLoading {
//                    ProgressView()
//                } else if let errorMessage = viewModel.errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                } else if let currentWeather = viewModel.currentWeather {
//                    CurrentWeatherView(weatherData: currentWeather, viewModel: viewModel)
//                    ForecastView(forecast: viewModel.forecast, viewModel: viewModel)
//                } else {
//                    Text("Enter a city name to see the weather forecast")
//                }
//            }
//            .navigationTitle("Weather Forecast")
//        }
//        .onAppear {
//            viewModel.loadCachedWeatherData()
//        }
//    }
//}

//struct ContentView: View {
//    @StateObject private var viewModel = WeatherViewModel()
//    
//    var body: some View {
//        TabView {
//            CurrentWeatherView(viewModel: viewModel)
//                .tabItem {
//                    Label("Current", systemImage: "sun.max.fill")
//                }
//            
//            FiveDayForecastView(viewModel: viewModel)
//                .tabItem {
//                    Label("5-Day Forecast", systemImage: "calendar")
//                }
//        }
//        .onAppear {
//            viewModel.loadCachedWeatherData()
//        }
//    }
//}



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
                    CurrentWeatherView(weatherData: currentWeather, viewModel: viewModel)
                    
                    NavigationLink(destination: FiveDayForecastView(viewModel: viewModel)) {
                        Text("Five Day Forecast")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                } else {
                    Text("Enter a city name to see the weather forecast")
                }
            }
            .navigationTitle("Weather Search")
        }
        .onAppear {
            viewModel.loadCachedWeatherData()
        }
    }
}




#Preview {
    ContentView()
}
