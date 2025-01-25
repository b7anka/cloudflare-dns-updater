//
//  MainView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingSettings = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $appState.selectedRecordId) {
                Section("mainView_title".localized()) {
                    ForEach(appState.dnsRecords) { record in
                        NavigationLink(value: record.id) {
                            DNSRecordRow(record: record)
                        }
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 250, ideal: 250, max: 250)
            .toolbar {
                ToolbarItem {
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItem {
                    Button(action: {
                        Task {
                            await appState.fetchRecords()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        } detail: {
            if let recordId = appState.selectedRecordId,
               let record = appState.dnsRecords.first(where: { $0.id == recordId }) {
                DNSRecordDetailView(record: record, appState: appState)
            } else {
                Text("mainView_noRecordSelected".localized())
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .task {
            await appState.fetchRecords()
        }
    }
}

#if DEBUG
#Preview {
    MainView()
}
#endif
