//
//  WindowManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import AppKit

class WindowManager: ObservableObject {
    
    static let shared = WindowManager()
    private var mainWindow: NSWindow?
    
    func setMainWindow(_ window: NSWindow?) {
        mainWindow = window
    }
    
    func showMainWindow() {
        if let window = mainWindow {
            if !window.isVisible {
                // NSApp.setActivationPolicy(.regular)
                window.setIsVisible(true)
            }
            window.orderFrontRegardless()
        }
    }
    
    func hideMainWindow() {
        if let window = mainWindow {
            window.setIsVisible(false)
            // NSApp.setActivationPolicy(.regular)  // Show dock icon
        }
    }
    
}
