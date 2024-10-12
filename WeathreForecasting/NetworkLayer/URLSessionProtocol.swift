//
//  URLSessionProtocol.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation
import Combine

protocol URLSessionType {
    func publisherForDataTask(with url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionType {
    func publisherForDataTask(with url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return dataTaskPublisher(for: url).eraseToAnyPublisher()
    }
}
