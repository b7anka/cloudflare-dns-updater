//
//  AppState.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

final class AppState: ObservableObject {
    
    @Published var dnsRecords: [DNSRecord] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedRecordId: String?
    
    private let repository: DNSRepositoryProtocol
    
    init(factory: DNSRepositoryFactory = DefaultDNSRepositoryFactory()) {
        self.repository = factory.makeDNSRepository()
        selectedRecordId = nil
    }
    
    @MainActor
    func fetchRecords() async {
        isLoading = true
        defer {
            isLoading = false
        }
        error = nil
        
        do {
            dnsRecords = try await repository.fetchDNSRecords()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func updateRecord(_ record: DNSRecord) async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            try await repository.updateDNSRecord(record)
            await fetchRecords()
        } catch {
            self.error = error
        }
    }
    
    @MainActor
    func deleteRecord(_ id: String?) async {
        isLoading = true
        error = nil
        defer {
            isLoading = false
        }
        
        do {
            try await repository.deleteDNSRecord(id)
            selectedRecordId = nil
            await fetchRecords()
        } catch {
            self.error = error
        }
    }
    
}
