//
//  DefaultAppStatusManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 27/01/2025.
//

import AppKit

final class DefaultAppStatusManager: AppStatusManager, ObservableObject {
    
    static let shared = DefaultAppStatusManager()
    
    private(set) var startMinimized: Bool
    private let storageManager: StorageManager
    private let logger: Logger
    
    private init(
        storageManagerFactory: StorageManagerFactory = DefaultStorageManagerFactory(),
        logger: Logger = DefaultLogger.shared
    ) {
        let storageManager = storageManagerFactory.makeStorageManager()
        self.storageManager = storageManager
        self.logger = logger
        self.startMinimized = storageManager.bool(forKey: .launchMinimized)
    }
    
    deinit {
        logger.logMessage(message: "DEFAULT APP STATUS MANAGER DEINIT CALLED")
    }
    
    func showApp() {
        NSApplication.shared.unhide(nil)
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    func hideApp() {
        let shouldQuitWhenClose: Bool = storageManager.bool(
            forKey: .quitWhenClosed
        )
        
        guard !shouldQuitWhenClose else {
            quitApp()
            return
        }
        
        hideAppImpl()
    }
    
    func hideDockIcon() {
        NSApplication.shared.setActivationPolicy(.accessory)
        startMinimized = false
    }
    
    private func hideAppImpl() {
        NSApplication.shared.hide(nil)
        NSApplication.shared.deactivate()
    }
    
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
}
