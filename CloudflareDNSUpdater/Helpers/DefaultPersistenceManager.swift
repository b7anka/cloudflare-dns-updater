//
//  DefaultPersistenceManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import SwiftData
import Foundation

@MainActor
final class DefaultPersistenceManager: ObservableObject, PersistenceManager {
    
    static let shared = DefaultPersistenceManager()
    
    private var container: ModelContainer?
    private var context: ModelContext?
    
    private init() {
        setupContainer()
    }
    
    private func setupContainer() {
        let schema = Schema([
            AutoUpdateRecord.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none
        )
        
        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            context = ModelContext(container!)
            
            // Configure container
            context?.autosaveEnabled = true
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD Operations
    
    func save<T: PersistentModel>(_ item: T) throws {
        guard let context else { throw PersistenceError.contextNotFound }
        context.insert(item)
        try context.save()
    }
    
    func fetch<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>? = nil, sortBy: [SortDescriptor<T>]? = nil) throws -> [T] {
        guard let context else { throw PersistenceError.contextNotFound }
        
        let descriptor = FetchDescriptor<T>(
            predicate: predicate,
            sortBy: sortBy ?? []
        )
        
        return try context.fetch(descriptor)
    }
    
    func update() throws {
        guard let context else { throw PersistenceError.contextNotFound }
        try context.save()
    }
    
    func delete<T: PersistentModel>(_ item: T) throws {
        guard let context else { throw PersistenceError.contextNotFound }
        context.delete(item)
        try context.save()
    }
    
    func deleteAll<T: PersistentModel>(_ type: T.Type) throws {
        guard let context else { throw PersistenceError.contextNotFound }
        try fetch(type).forEach { context.delete($0) }
        try context.save()
    }
    
}

#if DEBUG
extension DefaultPersistenceManager {
    
    // only for testing pourposes
    // swiftlint:disable:next identifier_name
    var _context: ModelContext? {
        get {
            context
        }
        set {
            context = newValue
        }
    }
    
}
#endif
