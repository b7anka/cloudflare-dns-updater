//
//  CloudflareDNSUpdaterApp.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI
import SwiftData

@main
struct CloudflareDNSUpdaterApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var persistenceManager: DefaultPersistenceManager = .shared
    @StateObject private var appStatusManager: DefaultAppStatusManager = .shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .environmentObject(persistenceManager)
                .frame(
                    minWidth: 800,
                    minHeight: 500
                )
        }
        // Menu bar extra
        MenuBarExtra("Cloudflare DNS", systemImage: "network") {
            MenuBarView()
                .environmentObject(appState)
                .environmentObject(appStatusManager)
        }
        .menuBarExtraStyle(.menu)
    }
    
}
