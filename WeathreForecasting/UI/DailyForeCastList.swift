//
//  DailyFOreCastList.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import SwiftUI

struct DailyForecastList: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        List(viewModel.getDailyForecast()) { dailyForecast in
            HStack {
                Text(viewModel.formatDate(dailyForecast.date.description))
                    .accessibility(identifier: "Date")
                Spacer()
                Text("H: \(viewModel.formatTemperature(dailyForecast.highTemperature))")
                    .accessibility(identifier: "HighTemp")

                Text("L: \(viewModel.formatTemperature(dailyForecast.lowTemperature))")
                    .accessibility(identifier: "LowTemp")

                Text(dailyForecast.condition)
                    .accessibility(identifier: "Condition")

            }
        }
        .accessibility(identifier: "DailyForecastList")

    }
}
