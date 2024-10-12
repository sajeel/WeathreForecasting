//
//  MockDataTaskPublisher.swift
//  WeathreForecastingTests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import XCTest
import Combine

struct MockDataTaskPublisher: Publisher {
    typealias Output = URLSession.DataTaskPublisher.Output
    typealias Failure = URLSession.DataTaskPublisher.Failure
    
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        if let error = error {
            subscriber.receive(completion: .failure(error as! URLError))
        } else if let data = data, let response = response {
            _ = subscriber.receive((data, response))
            subscriber.receive(completion: .finished)
        } else {
            subscriber.receive(completion: .failure(URLError(.unknown)))
        }
    }
}
