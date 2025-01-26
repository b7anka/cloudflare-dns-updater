//
//  MockDispatchQueue.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockDispatchQueue: DispatchQueueProtocol, Mock {
    
    nonisolated(unsafe) var storage = Storage()
    nonisolated(unsafe) var blockToExecute: (() -> Void)?
    
    func sync<T>(execute work: () throws -> T) rethrows -> T {
        recordCall(withIdentifier: "syncThrowing")
        blockToExecute?()
        return try work()
    }
    
    func async(_ block: @escaping @Sendable () -> Void) {
        recordCall(withIdentifier: "async")
        blockToExecute?()
        block()
    }

    func asyncAfter(
        deadline: DispatchTime,
        _ work: @escaping @Sendable () -> Void
    ) {
        recordCall(withIdentifier: "asyncAfter", arguments: [deadline])
        blockToExecute?()
        work()
    }

    func sync(execute block: () -> Void) {
        recordCall(withIdentifier: "sync")
        blockToExecute?()
        block()
    }
}
