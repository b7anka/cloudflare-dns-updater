//
//  MockUserDefaults.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockUserDefaults: UserDefaultsProtocol, Mock {
    
    nonisolated(unsafe) var storage = Storage()
    nonisolated(unsafe) var valueToReturn: Any?
    
    func string(forKey key: String) -> String? {
        recordCall(withIdentifier: "string", arguments: [key])
        return valueToReturn as? String
    }
    
    func bool(forKey key: String) -> Bool {
        recordCall(withIdentifier: "bool", arguments: [key])
        return valueToReturn as? Bool ?? false
    }
    
    func setValue(_ value: Any?, forKey key: String) {
        recordCall(withIdentifier: "setValue", arguments: [value, key])
    }
}
