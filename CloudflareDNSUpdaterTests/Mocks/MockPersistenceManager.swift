//
//  MockPersistenceManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import SwiftData
import Mimus
@testable import CloudflareDNSUpdater

final class MockPersistenceManager: PersistenceManager, Mock {

    var storage = Storage()
    var recordsToReturn: [AutoUpdateRecord]?
    
    func save<T>(_ item: T) throws where T: PersistentModel {
        recordCall(
            withIdentifier: "save",
            arguments: [String(describing: item)]
        )
    }

    func fetch<T>(_ type: T.Type, predicate: Predicate<T>?, sortBy: [SortDescriptor<T>]?) throws -> [T] where T: PersistentModel {
        recordCall(withIdentifier: "fetch", arguments: [String(describing: type), predicate, sortBy])
        return recordsToReturn as? [T] ?? []
    }

    func update() throws {
        recordCall(withIdentifier: "update")
    }

    func delete<T>(_ item: T) throws where T: PersistentModel {
        recordCall(
            withIdentifier: "delete",
            arguments: [String(describing: item)]
        )
    }

    func deleteAll<T>(_ type: T.Type) throws where T: PersistentModel {
        recordCall(
            withIdentifier: "deleteAll",
            arguments: [String(describing: type)]
        )
    }
}
