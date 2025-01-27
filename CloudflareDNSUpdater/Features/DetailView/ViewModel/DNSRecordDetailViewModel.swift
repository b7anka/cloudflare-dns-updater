//
//  DNSRecordDetailViewModel.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import SwiftUI

@MainActor
final class DNSRecordDetailViewModel: ObservableObject {
    
    @Published var editedName: String
    @Published var editedType: String
    @Published var editedContent: String
    @Published var editedTTL: Int
    @Published var editedProxied: Bool
    @Published var showingDeleteAlert: Bool
    @Published var autoUpdate: Bool {
        didSet {
            toggleAutoUpdate()
        }
    }
    @Published var isLoading: Bool
    
    private let record: DNSRecord
    private let persistenceManager: PersistenceManager
    private let repository: DNSRepositoryProtocol
    private let appState: MainViewViewModel
    private var autoUpdateRecords: [AutoUpdateRecord]
    private let logger: Logger
    
    var name: String {
        record.name ?? "New record".localized()
    }
    
    var showAutoUpdateRow: Bool {
        record.type == RecordType.a.rawValue
    }
    
    init(
        record: DNSRecord,
        persistenceManager: PersistenceManager,
        repositoryFactory: DNSRepositoryFactory,
        appState: MainViewViewModel,
        logger: Logger
    ) {
        self.persistenceManager = persistenceManager
        self.appState = appState
        self.logger = logger
        repository = repositoryFactory.makeDNSRepository()
        self.record = record
        self.editedName = record.nameOrNoValue
        self.editedType = record.typeOrNoValue
        self.editedContent = record.contentOrNoValue
        self.editedTTL = record.ttl ?? 1
        self.editedProxied = record.proxied
        self.showingDeleteAlert = false
        self.autoUpdate = false
        self.isLoading = false
        self.autoUpdateRecords = []
        fetchAutoUpdateRecords()
        checkIfRecordIsAutoUpdated()
    }
    
    deinit {
        logger.logMessage(message: "DNS RECORD DETAIL VIEW MODEL DEINIT")
    }
    
    func updateRecord() {
        Task {
            await updateRecordImpl()
        }
    }
    
    func deleteRecord() {
        Task {
            await deleteRecordImpl()
        }
    }
    
    private func updateRecordImpl() async {
        let updatedRecord = DNSRecord(
            id: record.id,
            name: editedName,
            type: editedType,
            content: editedContent,
            proxied: editedProxied,
            ttl: editedTTL
        )
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            try await repository.updateDNSRecord(updatedRecord)
            await appState.fetchRecords()
        } catch {
            
        }
        
    }
    
    private func deleteRecordImpl() async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            try await repository.deleteDNSRecord(record.id)
            try deleteFromLocalStorage()
        } catch {
            
        }
    }
    
    private func toggleAutoUpdate() {
        do {
            if autoUpdate {
                guard let id = record.id else {
                    return
                }
                let newAutoUpdateRecord = AutoUpdateRecord(
                    recordId: id,
                    recordName: record.nameOrNoValue
                )
                try persistenceManager.save(newAutoUpdateRecord)
            } else {
                try deleteFromLocalStorage()
                fetchAutoUpdateRecords()
            }
        } catch {
            
        }
    }
    
    private func deleteFromLocalStorage() throws {
        guard let existingRecord = autoUpdateRecords.first(where: { $0.recordId == record.id }) else {
            return
        }
        try persistenceManager.delete(existingRecord)
    }
    
    private func fetchAutoUpdateRecords() {
        do {
            autoUpdateRecords = try persistenceManager
                .fetch(AutoUpdateRecord.self, predicate: nil, sortBy: nil)
        } catch {
            
        }
    }
    
    private func checkIfRecordIsAutoUpdated() {
        autoUpdate = autoUpdateRecords.contains(where: { $0.recordId == record.id })
    }
    
}
