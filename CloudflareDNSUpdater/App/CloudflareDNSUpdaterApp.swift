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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let container: ModelContainer
    
    init() {
            // Configure the Schema and ModelConfiguration
            let schema = Schema([
                AutoUpdateRecord.self
            ])
            
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .none
            )
            
            // Initialize the container
            do {
                container = try ModelContainer(
                    for: schema,
                    configurations: [modelConfiguration]
                )
            } catch {
                fatalError("Could not initialize ModelContainer: \(error)")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .frame(
                    minWidth: 800,
                    minHeight: 500
                )
        }
        .modelContainer(container)
        // Menu bar extra
        MenuBarExtra("Cloudflare DNS", systemImage: "network") {
            MenuBarView()
                .environmentObject(appState)
                .environmentObject(appDelegate)
        }
        .menuBarExtraStyle(.menu)
    }
    
}
