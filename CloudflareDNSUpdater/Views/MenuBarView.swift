//
//  MenuBarView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var appDelegate: AppDelegate
    @Environment(\.modelContext) private var modelContext
    @StateObject private var backgroundTask = DefaultBackgroundTaskManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current IP: \(backgroundTask.currentIP ?? "Checking...")")
                .font(.system(.body, design: .monospaced))
            
            if let lastUpdate = backgroundTask.lastUpdate {
                Text("Last Update: \(lastUpdate, style: .time)")
                    .font(.caption)
            } else {
                Text("Last Update: IP hasn't changed yet")
                    .font(.caption)
            }
            
            if let error = backgroundTask.lastError {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Divider()
            
            if backgroundTask.isUpdating {
                ProgressView()
                    .scaleEffect(0.8)
            }
            
            Divider()
            
            Button("Open Main Window") {
                appDelegate.showMainWindow()
            }
            
            Button("Quit") {
                NSApp.terminate(nil)
            }
        }
        .padding()
        .frame(width: 250)
        .onAppear {
            backgroundTask.modelContext = modelContext
            backgroundTask.startBackgroundTask()
        }
        .onDisappear {
            backgroundTask.stopBackgroundTask()
        }
    }
}

#if DEBUG
#Preview {
    MenuBarView()
}
#endif
