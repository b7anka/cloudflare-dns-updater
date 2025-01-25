//
//  DispatchQueue+Custom.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

extension DispatchQueue: DispatchQueueProtocol {
    
    func asyncAfter(
        deadline: DispatchTime,
        _ work: @Sendable @escaping () -> Void
    ) {
        asyncAfter(deadline: deadline, execute: work)
    }

    func async(_ work: @Sendable @escaping () -> Void) {
        async(group: .none, execute: work)
    }
}
