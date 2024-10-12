//
//  CacheManagerTests.swift
//  WeathreForecastingTests
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import XCTest
@testable import WeathreForecasting

class CacheManagerTests: XCTestCase {
    var cacheManager: CacheManager!
    
    override func setUp() {
        super.setUp()
        cacheManager = CacheManager.shared
        // Clear any existing cache before each test
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    override func tearDown() {
        cacheManager = nil
        super.tearDown()
    }
    
    func testCacheAndRetrieveString() {
        // Given
        let key = "testString"
        let value = "Hello, World!"
        
        // When
        cacheManager.cache(value, forKey: key)
        let retrievedValue: String? = cacheManager.retrieve(String.self, forKey: key)
        
        // Then
        XCTAssertEqual(retrievedValue, value)
    }
    
    func testCacheAndRetrieveCustomObject() {
        // Given
        let key = "testObject"
        let value = TestObject(id: 1, name: "Test")
        
        // When
        cacheManager.cache(value, forKey: key)
        let retrievedValue: TestObject? = cacheManager.retrieve(TestObject.self, forKey: key)
        
        // Then
        XCTAssertEqual(retrievedValue?.id, value.id)
        XCTAssertEqual(retrievedValue?.name, value.name)
    }
    
    func testRemoveObject() {
        // Given
        let key = "testRemove"
        let value = "Remove me"
        cacheManager.cache(value, forKey: key)
        
        // When
        cacheManager.remove(forKey: key)
        let retrievedValue: String? = cacheManager.retrieve(String.self, forKey: key)
        
        // Then
        XCTAssertNil(retrievedValue)
    }
    
    func testCacheLastUpdated() {
        // Given
        let key = "testTimestamp"
        let value = "Timestamp test"
        
        // When
        cacheManager.cache(value, forKey: key)
        cacheManager.cacheLastUpdated(forKey: key)
        
        // Then
        let lastUpdated = cacheManager.lastUpdated(forKey: key)
        XCTAssertNotNil(lastUpdated)
        XCTAssertLessThanOrEqual(lastUpdated!.timeIntervalSinceNow, 1) // Should be less than 1 second ago
    }
    
    func testRetrieveNonExistentObject() {
        // Given
        let key = "nonExistent"
        
        // When
        let retrievedValue: String? = cacheManager.retrieve(String.self, forKey: key)
        
        // Then
        XCTAssertNil(retrievedValue)
    }
    
    func testCacheOverwrite() {
        // Given
        let key = "overwrite"
        let initialValue = "Initial"
        let newValue = "New"
        
        // When
        cacheManager.cache(initialValue, forKey: key)
        cacheManager.cache(newValue, forKey: key)
        let retrievedValue: String? = cacheManager.retrieve(String.self, forKey: key)
        
        // Then
        XCTAssertEqual(retrievedValue, newValue)
    }
}

// A simple object for testing custom object caching
struct TestObject: Codable, Equatable {
    let id: Int
    let name: String
}
