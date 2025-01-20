//
//  DefaultUserDefaultsFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

struct DefaultUserDefaultsFactory: UserDefaultsFactory {
    
    func makeUserDefaults() -> UserDefaultsProtocol {
        return UserDefaults.standard
    }
    
}
