//
//  MockStorageManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockStorageManager: StorageManager, Mock {
    
    nonisolated(unsafe) var storage = Storage()
    nonisolated(unsafe) var valueToReturn: Any?
    
    func string(forKey key: UserDefaultsKey) -> String? {
        recordCall(withIdentifier: "string", arguments: [key.rawValue])
        return valueToReturn as? String
    }
    
    func bool(forKey key: UserDefaultsKey) -> Bool {
        recordCall(withIdentifier: "bool", arguments: [key.rawValue])
        return valueToReturn as? Bool ?? false
    }
    
    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        recordCall(withIdentifier: "set", arguments: [value, key.rawValue])
    }
    
}
