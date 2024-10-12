//
//  CacheManager.swift
//  WeathreForecasting
//
//  Created by Sajjeel Hussain Khilji on 12/10/2024.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private init() {}
    
    func cache<T: Encodable>(_ object: T, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error caching object: \(error.localizedDescription)")
        }
    }
    
    func retrieve<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print("Error retrieving cached object: \(error.localizedDescription)")
            return nil
        }
    }
    
    func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func cacheLastUpdated(forKey key: String) {
        let timestamp = Date().timeIntervalSince1970
        UserDefaults.standard.set(timestamp, forKey: key + "_timestamp")
    }
    
    func lastUpdated(forKey key: String) -> Date? {
        guard let timestamp = UserDefaults.standard.object(forKey: key + "_timestamp") as? TimeInterval else {
            return nil
        }
        return Date(timeIntervalSince1970: timestamp)
    }
}
