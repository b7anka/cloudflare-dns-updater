//
//  MainViewViewModel.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

final class MainViewViewModel: ObservableObject {
    
    @Published private(set) var dnsRecords: [DNSRecord] = []
    @Published private(set) var isLoading = false
    @Published var showSettings = false
    @Published private(set) var error: Error?
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
    
    func showSettingsView() {
        showSettings = true
    }
    
}
