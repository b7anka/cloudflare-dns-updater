//
//  DefaultStorageManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

final class DefaultStorageManager: StorageManager {
    
    private let defaults: UserDefaultsProtocol
    private let queue: DispatchQueueProtocol
    
    init(
        userDefaultsFactory: UserDefaultsFactory,
        queue: DispatchQueueProtocol
    ) {
        self.defaults = userDefaultsFactory.makeUserDefaults()
        self.queue = queue
    }
    
    func string(forKey key: UserDefaultsKey) -> String? {
        queue.sync { [weak self] in
            return self?.defaults.string(forKey: key.rawValue)
        }
    }

    func bool(forKey key: UserDefaultsKey) -> Bool {
        queue.sync { [weak self] in
            return self?.defaults.bool(forKey: key.rawValue) ?? false
        }
    }

    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        queue.sync { [weak self] in
            self?.defaults.setValue(value, forKey: key.rawValue)
        }
    }
    
}
