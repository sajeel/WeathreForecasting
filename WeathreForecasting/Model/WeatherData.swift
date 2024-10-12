//
//  WeatherData.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import SwiftUI
// MARK: - Models

struct WeatherData: Codable {
    let current: CurrentWeather
    let forecast: Forecast
}

