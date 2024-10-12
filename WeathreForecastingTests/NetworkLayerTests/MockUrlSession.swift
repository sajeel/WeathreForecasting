//
//  MockUrlSession.swift
//  WeathreForecastingTests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import XCTest
import Combine
@testable import WeathreForecasting

class MockURLSession: URLSessionType {
    var data: Data?
    var response: URLResponse?
    var error: URLError?
    
    func publisherForDataTask(with url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        guard let data = data, let response = response else {
            return Fail(error: URLError(.unknown)).eraseToAnyPublisher()
        }
        
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
