//
//  MockNetworkMonitor.swift
//  WeathreForecastingTests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import XCTest
import Combine
import Network
@testable import WeathreForecasting


class MockNetworkMonitor: NetworkMonitoringProtocol {
    var isConnected: Bool = true
    
    func startMonitoring() {}
    func stopMonitoring() {}
}
