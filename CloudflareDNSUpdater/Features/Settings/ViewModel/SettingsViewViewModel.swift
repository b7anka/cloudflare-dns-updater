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
    @Published var startMinimized: Bool {
        didSet {
            saveSettings()
        }
    }
    @Published var quitWhenClosed: Bool {
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
        self.startMinimized = storageManager.bool(forKey: .launchMinimized)
        self.quitWhenClosed = storageManager.bool(forKey: .quitWhenClosed)
        self.logger = logger
        self.storageManager = storageManager
    }
    
    private func saveSettings() {
        storageManager.set(apiToken, forKey: .cloudflareApiToken)
        storageManager.set(zoneId, forKey: .cloudflareZoneId)
        storageManager.set(startMinimized, forKey: .launchMinimized)
        storageManager.set(quitWhenClosed, forKey: .quitWhenClosed)
    }
    
}
