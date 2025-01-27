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
            Text(
                "\("menuBarView_currentIP".localized()) \(backgroundTask.currentIP ?? "menuBarView_checking".localized())"
            )
                .font(.system(.body, design: .monospaced))
            
            if let lastUpdate = backgroundTask.lastUpdate {
                Text("\("menuBarView_lastUpdate".localized()) \(lastUpdate, style: .time)")
                    .font(.caption)
            } else {
                Text(
                    "\("menuBarView_lastUpdate".localized()) \("menuBarView_ipNotChanged".localized())"
                )
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
            
            Button("menuBarView_openMainWindow".localized()) {
                appDelegate.showMainWindow()
            }
            
            Button("general_quit".localized()) {
                NSApp.terminate(nil)
            }
        }
        .padding()
        .frame(width: 250)
        .onAppear {
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
