//
//  DispatchQueue+Custom.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

extension DispatchQueue: DispatchQueueProtocol {
    
    func asyncAfter(deadline: DispatchTime, _ work: @escaping () -> Void) {
        asyncAfter(deadline: deadline, execute: work)
    }

    func async(_ work: @escaping () -> Void) {
        async(group: .none, execute: work)
    }
}
