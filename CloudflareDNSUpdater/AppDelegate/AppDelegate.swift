//
//  AppDelegate.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return shouldHandleReopen()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.delegate = self
        }
    }
    
    func applicationDidHide(_ notification: Notification) {
        perform(#selector(hideDockIcon), with: nil, afterDelay: 0.5)
    }
    
    @MainActor
    private func shouldHandleReopen() -> Bool {
        let startMinimized = DefaultAppStatusManager.shared.startMinimized
        if startMinimized {
            DefaultAppStatusManager.shared.hideApp()
        }
        return !startMinimized
    }
    
    @MainActor
    @objc private func hideDockIcon() {
        DefaultAppStatusManager.shared.hideDockIcon()
    }
    
}

extension AppDelegate: NSWindowDelegate {
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        DefaultAppStatusManager.shared.hideApp()
        return false
    }
    
}
