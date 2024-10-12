//
//  ForecastView.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI
 
struct ForecastView: View {
    let forecast: [DailyForecast]
    
    var body: some View {
        List(forecast) { day in
            HStack {
                Text(formatDate(day.date))
                Spacer()
                Text("\(Int(day.temperatureLow))°C - \(Int(day.temperatureHigh))°C")
                Text(day.condition)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
 
