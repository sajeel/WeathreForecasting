//
//  NetworkMonitoringProtocol.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import Network

protocol NetworkMonitoringProtocol {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

class RealNetworkMonitor: NetworkMonitoringProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
