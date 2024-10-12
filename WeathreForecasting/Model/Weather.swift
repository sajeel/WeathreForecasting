//
//  Weather.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import SwiftUI
 
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
    
    init(id: Int, main: String, description: String, icon: String) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
      
}

struct Clouds: Codable {
    let all: Int
    init(all: Int) {
        self.all = all
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
    init(speed: Double, deg: Int, gust: Double?) {
        self.speed = speed
        self.deg = deg
        self.gust = gust
    }
}

struct Sys: Codable {
    let pod: String
}
