//
//  MockUserDefaultsFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockUserDefaultsFactory: UserDefaultsFactory, Mock {
    
    var storage = Storage()
    var userDefaultsToReturn: UserDefaultsProtocol?
    
    func makeUserDefaults() -> UserDefaultsProtocol {
        recordCall(withIdentifier: "makeUserDefaults")
        return userDefaultsToReturn ?? MockUserDefaults()
    }
    
}
