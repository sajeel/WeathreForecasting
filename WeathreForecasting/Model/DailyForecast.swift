//
//  DailyForecast.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation

public struct DailyForecast: Identifiable, Codable {
    public var id = UUID()
    let date: Date
    let highTemperature: Double
    let lowTemperature: Double
    let condition: String
    
    public init(id: UUID = UUID(), date: Date, highTemperature: Double, lowTemperature: Double, condition: String) {
        self.id = id
        self.date = date
        self.highTemperature = highTemperature
        self.lowTemperature = lowTemperature
        self.condition = condition
    }
}

 
