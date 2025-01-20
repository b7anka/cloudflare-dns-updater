//
//  DNSRepositoryFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

protocol DNSRepositoryFactory {
    func makeDNSRepository() -> DNSRepositoryProtocol
}
