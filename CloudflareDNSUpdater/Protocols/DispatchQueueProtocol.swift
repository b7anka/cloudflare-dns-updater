//
//  DispatchQueueProtocol.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

protocol DispatchQueueProtocol: AnyObject {
    @preconcurrency
    func async(
        execute work: @escaping @Sendable () -> Void
    )
    func sync(execute block: () -> Void)
}
