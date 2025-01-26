//
//  SettingsViewViewModel.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation

final class SettingsViewViewModel: ObservableObject {
    
    @Published var apiToken: String {
        didSet {
            saveSettings()
        }
    }
    @Published var zoneId: String {
        didSet {
            saveSettings()
        }
    }
    @Published var launchAtLogin: Bool {
        didSet {
            saveSettings()
        }
    }
    
    private let logger: Logger
    private let storageManager: StorageManager
    
    init(
        logger: Logger,
        storageManagerFactory: StorageManagerFactory
    ) {
        let storageManager: StorageManager = storageManagerFactory.makeStorageManager()
        self.apiToken = storageManager.string(forKey: .cloudflareApiToken) ?? ""
        self.zoneId = storageManager.string(forKey: .cloudflareZoneId) ?? ""
        self.launchAtLogin = storageManager.bool(forKey: .launchAtLogin)
        self.logger = logger
        self.storageManager = storageManager
    }
    
    
    private func saveSettings() {
        storageManager.set(apiToken, forKey: .cloudflareApiToken)
        storageManager.set(zoneId, forKey: .cloudflareZoneId)
        storageManager.set(launchAtLogin, forKey: .launchAtLogin)
    }
    
}
