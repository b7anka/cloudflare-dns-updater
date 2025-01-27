//
//  MainView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: MainViewViewModel
    
    init(
        factory: MainViewViewModelFactory = DefaultMainViewViewModelFactory()
    ) {
        _viewModel = StateObject(
            wrappedValue: factory.makeMainViewViewModel()
        )
    }
    
    var body: some View {
        NavigationSplitView {
            recordsList
        } detail: {
            recordDetailsView
        }
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
        .task {
            await viewModel.fetchRecords()
        }
    }
    
    // MARK: - RECORDS LIST
    @ViewBuilder private var recordsList: some View {
        List(selection: $viewModel.selectedRecordId) {
            recordsListSection
        }
        .navigationSplitViewColumnWidth(min: 250, ideal: 250, max: 250)
        .toolbar {
            showSettingsButton
            refreshRecordsButton
        }
    }
    
    // MARK: - RECORDS LIST SECTION
    @ViewBuilder private var recordsListSection: some View {
        Section("mainView_title".localized()) {
            ForEach(viewModel.dnsRecords) { record in
                NavigationLink(value: record.id) {
                    DNSRecordRow(record: record)
                }
            }
        }
    }
    
    // MARK: - SHOW SETTINGS BUTTON
    private var showSettingsButton: ToolbarItem<(), Button<Image>> {
        ToolbarItem {
            Button(action: viewModel.showSettingsView) {
                Image(systemName: "gear")
            }
        }
    }
    
    // MARK: - REFRESH RECORDS BUTTON
    private var refreshRecordsButton: ToolbarItem<(), Button<Image>> {
        ToolbarItem {
            Button(action: {
                Task {
                    await viewModel.fetchRecords()
                }
            }) {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    // MARK: - RECORD DETAILS VIEW
    @ViewBuilder private var recordDetailsView: some View {
        if let recordId = viewModel.selectedRecordId,
           let record = viewModel.dnsRecords.first(where: { $0.id == recordId }) {
            DNSRecordDetailView(record: record, appState: viewModel)
        } else {
            Text("mainView_noRecordSelected".localized())
                .foregroundColor(.secondary)
        }
    }
    
}

#if DEBUG
#Preview {
    MainView()
}
#endif
