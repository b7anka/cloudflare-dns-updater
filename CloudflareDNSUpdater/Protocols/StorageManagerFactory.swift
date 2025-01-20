//
//  StorageManagerFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

protocol StorageManagerFactory {
    func makeStorageManager() -> StorageManager
}
