//
//  DNSRecordDetailView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI
import SwiftData

struct DNSRecordDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: DNSRecordDetailViewModel
    
    init(
        record: DNSRecord,
        viewModelFactory: DNSRecordDetailViewViewModelFactory = DefaultDNSRecordDetailViewViewModelFactory(),
        appState: AppState
    ) {
        _viewModel = ObservedObject(
            wrappedValue: viewModelFactory
                .makeViewModel(for: record, with: appState)
        )
    }
    
    var body: some View {
        Form {
            infoSection
            buttonsSection
        }
        .formStyle(.grouped)
        .padding()
        .navigationTitle(viewModel.name)
        .alert(
            "alertView_deleteRecordTitle".localized(),
            isPresented: $viewModel.showingDeleteAlert
        ) {
            alertButtons
        } message: {
            Text("alertView_youSureDeleteRecord".localized())
        }
        .overlay {
            loadingView
        }
    }
    
    @ViewBuilder
    private var infoSection: some View {
        Section("recordDetailsView_recordDetails".localized()) {
            TextField(
                "recordDetailsView_name".localized(),
                text: $viewModel.editedName
            )
            TextField(
                "recordDetailsView_type".localized(),
                text: $viewModel.editedType
            )
            TextField(
                "recordDetailsView_content".localized(),
                text: $viewModel.editedContent
            )
            Stepper(
                "\("recordDetailsView_ttl".localized()) \(viewModel.editedTTL)",
                value: $viewModel.editedTTL,
                in: 1...86400
            )
            Toggle(
                "recordDetailsView_proxied".localized(),
                isOn: $viewModel.editedProxied
            )
            
            if viewModel.showAutoUpdateRow {
                Toggle(
                    "recordDetailsView_autoUpdate".localized(),
                    isOn: $viewModel.autoUpdate
                )
            }
            
        }
    }
    
    @ViewBuilder
    private var buttonsSection: some View {
        Section {
            HStack {
                Button(action: viewModel.updateRecord) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                        Text("recordDetailsView_updateRecord".localized())
                    }
                }
                .disabled(viewModel.isLoading)
                
                Spacer()
                
                Button(role: .destructive, action: { viewModel.showingDeleteAlert = true }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("recordDetailsView_deleteRecord".localized())
                    }
                }
                .disabled(viewModel.isLoading)
            }
        }
    }
    
    @ViewBuilder
    private var alertButtons: some View {
        Button("general_cancelButton".localized(), role: .cancel) { }
        Button("general_deleteButton".localized(), role: .destructive) {
            viewModel.deleteRecord()
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
        }
    }

}

#if DEBUG
#Preview {
    let record = DNSRecord(
        id: "1234567890",
        name: "example.com",
        type: "A",
        content: "192.168.1.1",
        proxied: false,
        ttl: 300
    )
    DNSRecordDetailView(
        record: record,
        viewModelFactory: DefaultDNSRecordDetailViewViewModelFactory(),
        appState: AppState()
    )
}
#endif
