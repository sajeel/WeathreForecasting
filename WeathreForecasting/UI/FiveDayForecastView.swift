//
//  FiveDayForecastView.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI

struct FiveDayForecastView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        List(viewModel.getDailyForecast()) { dailyForecast in
            VStack(alignment: .leading) {
                Text(viewModel.formatDate(dailyForecast.date.description))
                    .font(.headline)
                HStack {
                    Image(systemName: weatherIconName(for: dailyForecast.condition))
                    Text(dailyForecast.condition)
                        .font(.subheadline)
                }
                HStack {
                    Text("High: \(viewModel.formatTemperature(dailyForecast.highTemperature))")
                    Spacer()
                    Text("Low: \(viewModel.formatTemperature(dailyForecast.lowTemperature))")
                }
                .font(.subheadline)
            }
        }
        .navigationTitle("5-Day Forecast")
    }
    
    func weatherIconName(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return "sun.max.fill"
        case "clouds":
            return "cloud.fill"
        case "rain":    
            return "cloud.rain.fill"
        case "snow":
            return "cloud.snow.fill"
        default:
            return "cloud.fill"
        }
    }
}
