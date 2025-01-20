//
//  StorageManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

protocol StorageManager: AnyObject {
    
    func string(forKey key: UserDefaultsKey) -> String?
    func bool(forKey key: UserDefaultsKey) -> Bool
    func set(_ value: Any?, forKey key: UserDefaultsKey)
    
}
