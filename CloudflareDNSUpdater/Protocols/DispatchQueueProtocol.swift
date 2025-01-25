//
//  DispatchQueueProtocol.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

protocol DispatchQueueProtocol: Sendable, AnyObject {
    func async(_ block: @escaping @Sendable () -> Void)
    func asyncAfter(
        deadline: DispatchTime,
        _ work: @escaping @Sendable () -> Void
    )
    func sync(execute block: () -> Void)
    func sync<T>(execute work: () throws -> T) rethrows -> T
}
