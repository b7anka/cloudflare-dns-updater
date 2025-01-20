//
//  DispatchQueue+Custom.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

extension DispatchQueue: DispatchQueueProtocol {
    func async(execute work: @escaping @Sendable () -> Void) {
        async(group: .none, execute: work)
    }
}
