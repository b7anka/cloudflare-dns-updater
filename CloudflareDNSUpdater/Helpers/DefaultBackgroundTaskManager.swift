//
//  DefaultBackgroundTaskManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation
import SwiftData

@MainActor
final class DefaultBackgroundTaskManager: ObservableObject, @preconcurrency BackgroundTaskManager {
    private var timer: Timer?
    private let interval: TimeInterval
    private nonisolated let repository: DNSRepositoryProtocol
    private nonisolated let storage: StorageManager
    private nonisolated let ipService: IPAddressService
    @Published var lastUpdate: Date?
    @Published var currentIP: String?
    @Published var isUpdating: Bool = false
    @Published var lastError: Error?
    var modelContext: ModelContext?
    
    init(
        interval: TimeInterval = 300, // Default to 5 minutes
        ipAddressService: IPAddressService = DefaultIPAddressService(),
        factory: DNSRepositoryFactory = DefaultDNSRepositoryFactory(),
        storageFactory: StorageManagerFactory = DefaultStorageManagerFactory()
    ) {
        let storage = storageFactory.makeStorageManager()
        self.interval = interval
        self.repository = factory.makeDNSRepository()
        self.ipService = ipAddressService
        self.storage = storage
        self.currentIP = storage.string(forKey: .lastknownIpAddress)
    }
    
    func startBackgroundTask() {
        // Run immediately first
        Task {
            await checkAndUpdateRecords()
        }
        
        // Then set up timer for periodic updates
        timer = Timer
            .scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
                guard let self else { return }
                Task { @MainActor in
                    await self.checkAndUpdateRecords()
                }
            }
    }
    
    func stopBackgroundTask() {
        timer?.invalidate()
        timer = nil
    }
    
    @MainActor
    private func checkAndUpdateRecords() async {
        guard !isUpdating else { return }
        
        isUpdating = true
        defer {
            isUpdating = false
        }
        lastError = nil
        
        do {
            // Get current IP address
            let newIP = try await ipService.getCurrentIPAddress()
            guard newIP != currentIP else {
                lastUpdate = nil
                isUpdating = false
                return
            }
            currentIP = newIP
            storage.set(newIP, forKey: .lastknownIpAddress)
            
            // Fetch all DNS records
            let records = try await repository.fetchDNSRecords()
            
            // Get auto-update records from SwiftData
            let descriptor = FetchDescriptor<AutoUpdateRecord>()
            let autoUpdateRecords = try modelContext?.fetch(descriptor)
            let autoUpdateIds = Set(
                (autoUpdateRecords ?? []).map { $0.recordId
                })
            
            // Filter for A records and check if update needed
            for record in records where record.type == RecordType.a.rawValue && autoUpdateIds.contains(
                record.id ?? ""
            ) {
                if record.content != newIP {
                    // Create updated record
                    let updatedRecord = DNSRecord(
                        id: record.id,
                        name: record.name,
                        type: record.type,
                        content: newIP,
                        proxied: record.proxied,
                        ttl: record.ttl
                    )
                    
                    // Update the record
                    try await repository.updateDNSRecord(updatedRecord)
                }
            }
            
            lastUpdate = Date()
        } catch {
            lastError = error
        }
        
    }
}
