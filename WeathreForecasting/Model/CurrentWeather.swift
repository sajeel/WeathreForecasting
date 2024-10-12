//
//  CurrentWeather.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
struct CurrentWeather: Codable {
    let temperature: Double
    let humidity: Int
    let windSpeed: Double
    let description: String
}

