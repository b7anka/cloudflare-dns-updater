//
//  DNSRepositoryProtocol.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

protocol DNSRepositoryProtocol: Sendable, AnyObject {
    func fetchDNSRecords() async throws -> [DNSRecord]
    func updateDNSRecord(_ record: DNSRecord) async throws
    func createDNSRecord(_ record: DNSRecord) async throws
    func deleteDNSRecord(_ id: String?) async throws
}
