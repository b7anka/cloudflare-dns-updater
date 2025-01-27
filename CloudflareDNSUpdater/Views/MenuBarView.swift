//
//  MenuBarView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI

struct MenuBarView: View {
    
    @EnvironmentObject var appStatusManager: DefaultAppStatusManager
    @Environment(\.modelContext) private var modelContext
    @StateObject private var backgroundTask = DefaultBackgroundTaskManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            currentIPAddressView
            lastUpdateStatusView
            errorView
            Divider()
            loadingView
            Divider()
            openMainWindowButton
            quitButton
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
    
    // MARK: - CURRENT IP ADDRESS VIEW
    @ViewBuilder private var currentIPAddressView: some View {
        Text(
            "\("menuBarView_currentIP".localized()) \(backgroundTask.currentIP ?? "menuBarView_checking".localized())"
        )
            .font(.system(.body, design: .monospaced))
    }
    
    // MARK: - LAST UPDATE STATUS VIEW
    @ViewBuilder private var lastUpdateStatusView: some View {
        if let lastUpdate = backgroundTask.lastUpdate {
            Text("\("menuBarView_lastUpdate".localized()) \(lastUpdate, style: .time)")
                .font(.caption)
        } else {
            Text(
                "\("menuBarView_lastUpdate".localized()) \("menuBarView_ipNotChanged".localized())"
            )
                .font(.caption)
        }
    }
    
    // MARK: - ERROR VIEW
    @ViewBuilder private var errorView: some View {
        if let error = backgroundTask.lastError {
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
    
    // MARK: - LOADING VIEW
    @ViewBuilder private var loadingView: some View {
        if backgroundTask.isUpdating {
            ProgressView()
                .scaleEffect(0.8)
        }
    }
    
    // MARK: - OPEN MAIN WINDOW BUTTON
    @ViewBuilder private var openMainWindowButton: some View {
        Button("menuBarView_openMainWindow".localized()) {
            appStatusManager.showApp()
        }
    }
    
    // MARK: - QUIT BUTTON
    @ViewBuilder private var quitButton: some View {
        Button("general_quit".localized()) {
            NSApp.terminate(nil)
        }
    }
}

#if DEBUG
#Preview {
    MenuBarView()
}
#endif
