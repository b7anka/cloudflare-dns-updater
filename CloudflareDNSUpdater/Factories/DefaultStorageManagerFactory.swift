//
//  DefaultStorageManagerFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

struct DefaultStorageManagerFactory: StorageManagerFactory {
    
    func makeStorageManager() -> StorageManager {
        let userDefaultsFactory: UserDefaultsFactory = DefaultUserDefaultsFactory()
        let queue: DispatchQueueProtocol = DispatchQueue(label: "pt.tiagomoreira.dnsupdater.storage")
        return DefaultStorageManager(
            userDefaultsFactory: userDefaultsFactory,
            queue: queue,
            logger: DefaultLogger.shared
        )
    }
    
}
