//
//  PersistenceManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import SwiftData

@MainActor
public protocol PersistenceManager: AnyObject {
    func save<T: PersistentModel>(_ item: T) throws
    func fetch<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>?, sortBy: [SortDescriptor<T>]?) throws -> [T]
    func update() throws
    func delete<T: PersistentModel>(_ item: T) throws
    func deleteAll<T: PersistentModel>(_ type: T.Type) throws
}
