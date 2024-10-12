//
//  DailyForecast.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation

struct DailyForecast: Codable, Identifiable {
    var id = UUID()
    let date: Date
    let temperatureHigh: Double
    let temperatureLow: Double
    let condition: String
}
