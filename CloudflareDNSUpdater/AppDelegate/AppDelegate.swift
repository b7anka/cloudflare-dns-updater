//
//  AppDelegate.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Prevent app termination when closing the last window
        return false
    }
    
    func showMainWindow() {
        
    }
    
}
