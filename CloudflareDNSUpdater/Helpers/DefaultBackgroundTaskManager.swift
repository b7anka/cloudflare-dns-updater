//
//  DefaultBackgroundTaskManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

@MainActor
final class DefaultBackgroundTaskManager: ObservableObject, BackgroundTaskManager {
    
    @Published var lastUpdate: Date?
    @Published var currentIP: String?
    @Published var isUpdating: Bool = false
    @Published var lastError: Error?
    private var timer: Timer?
    private let interval: TimeInterval
    private nonisolated let repository: DNSRepositoryProtocol
    private nonisolated let storage: StorageManager
    private nonisolated let ipService: IPAddressService
    private let persistanceManager: PersistenceManager
    private let logger: Logger
    
    init(
        interval: TimeInterval = 300, // Default to 5 minutes
        ipAddressService: IPAddressService = DefaultIPAddressService(),
        factory: DNSRepositoryFactory = DefaultDNSRepositoryFactory(),
        storageFactory: StorageManagerFactory = DefaultStorageManagerFactory(),
        persistanceManager: PersistenceManager = DefaultPersistenceManager.shared,
        logger: Logger = DefaultLogger.shared
    ) {
        let storage = storageFactory.makeStorageManager()
        self.logger = logger
        self.persistanceManager = persistanceManager
        self.interval = interval
        self.repository = factory.makeDNSRepository()
        self.ipService = ipAddressService
        self.storage = storage
        self.currentIP = storage.string(forKey: .lastknownIpAddress)
    }
    
    deinit {
        logger.logMessage(message: "DEFAULT BACKGROUND TASK MANAGER DEINIT CALLED")
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
            
            let autoUpdateRecords = try persistanceManager.fetch(
                AutoUpdateRecord.self,
                predicate: nil,
                sortBy: nil
            )
            let autoUpdateIds = Set(
                autoUpdateRecords.map { $0.recordId
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
