//
//  MockStorageManagerFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockStorageManagerFactory: StorageManagerFactory, Mock {
    
    var storage = Storage()
    var storageToReturn: StorageManager?
    
    func makeStorageManager() -> StorageManager {
        recordCall(withIdentifier: "makeStorageManager")
        return storageToReturn ?? MockStorageManager()
    }
    
}
