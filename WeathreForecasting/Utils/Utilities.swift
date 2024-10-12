//
//  Utilities.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
// MARK: - Extensions

extension Array where Element: Hashable {
    var mostCommon: Element? {
        let counts = self.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        return counts.max(by: { $0.value < $1.value })?.key
    }
}

