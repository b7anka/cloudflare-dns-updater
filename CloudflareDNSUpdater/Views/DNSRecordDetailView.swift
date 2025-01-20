//
//  DNSRecordDetailView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI
import SwiftData

struct DNSRecordDetailView: View {
    
    let record: DNSRecord
    @State private var editedName: String = ""
    @State private var editedType: String = ""
    @State private var editedContent: String = ""
    @State private var editedTTL: Int = 1
    @State private var editedProxied: Bool = false
    @State private var showingDeleteAlert = false
    @State private var autoUpdate: Bool = false
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var autoUpdateRecords: [AutoUpdateRecord]
    
    init(record: DNSRecord) {
        self.record = record
        _editedName = State(initialValue: record.nameOrNoValue)
        _editedType = State(initialValue: record.typeOrNoValue)
        _editedContent = State(initialValue: record.contentOrNoValue)
        _editedTTL = State(initialValue: record.ttl ?? 0)
        _editedProxied = State(initialValue: record.proxied)
    }
    
    var body: some View {
        Form {
            Section("recordDetailsView_recordDetails".localized()) {
                TextField(
                    "recordDetailsView_name".localized(),
                    text: $editedName
                )
                TextField(
                    "recordDetailsView_type".localized(),
                    text: $editedType
                )
                TextField(
                    "recordDetailsView_content".localized(),
                    text: $editedContent
                )
                Stepper("\("recordDetailsView_ttl".localized()) \(editedTTL)", value: $editedTTL, in: 1...86400)
                Toggle(
                    "recordDetailsView_proxied".localized(),
                    isOn: $editedProxied
                )
                
                
                if record.type == RecordType.a.rawValue {
                    Toggle(
                        "recordDetailsView_autoUpdate".localized(),
                        isOn: $autoUpdate
                    )
                        .onChange(of: autoUpdate) { oldValue, newValue in
                            if newValue {
                                // Add to auto-update list
                                guard let id = record.id else { return }
                                let autoUpdateRecord = AutoUpdateRecord(
                                    recordId: id,
                                    recordName: record.nameOrNoValue
                                )
                                modelContext.insert(autoUpdateRecord)
                            } else {
                                // Remove from auto-update list
                                if let existingRecord = autoUpdateRecords.first(where: { $0.recordId == record.id }) {
                                    modelContext.delete(existingRecord)
                                }
                            }
                            
                            // Save changes
                            try? modelContext.save()
                        }
                }
                
                
            }
            
            Section {
                HStack {
                    Button(action: updateRecord) {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                            Text("recordDetailsView_updateRecord".localized())
                        }
                    }
                    .disabled(appState.isLoading)
                    
                    Spacer()
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("recordDetailsView_deleteRecord".localized())
                        }
                    }
                    .disabled(appState.isLoading)
                }
            }
        }
        .formStyle(.grouped)
        .padding()
        .navigationTitle(record.nameOrNoValue)
        .alert(
            "alertView_deleteRecordTitle".localized(),
            isPresented: $showingDeleteAlert
        ) {
            Button("general_cancelButton".localized(), role: .cancel) { }
            Button("general_deleteButton".localized(), role: .destructive) {
                deleteRecord()
            }
        } message: {
            Text("alertView_youSureDeleteRecord".localized())
        }
        .overlay {
            if appState.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            updateFields()
        }
        .onChange(of: record) { oldValue, newValue in
            updateFields()
        }
    }
    
    private func updateFields() {
        editedName = record.nameOrNoValue
        editedType = record.typeOrNoValue
        editedContent = record.contentOrNoValue
        editedTTL = record.ttl ?? 0
        editedProxied = record.proxied
        autoUpdate = autoUpdateRecords.contains(where: { $0.recordId == record.id })
    }
    
    private func updateRecord() {
        let updatedRecord = DNSRecord(
            id: record.id,
            name: editedName,
            type: editedType,
            content: editedContent,
            proxied: editedProxied,
            ttl: editedTTL
        )
        
        Task {
            await appState.updateRecord(updatedRecord)
        }
    }
    
    private func deleteRecord() {
        Task {
            await appState.deleteRecord(record.id)
        }
        
        // Remove from auto-update if exists
        if let existingRecord = autoUpdateRecords.first(where: { $0.recordId == record.id }) {
            modelContext.delete(existingRecord)
            try? modelContext.save()
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
    DNSRecordDetailView(record: record)
}
#endif
