//
//  MockDNSRepository.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockDNSRepository: DNSRepositoryProtocol, Mock {

    nonisolated(unsafe) var storage = Storage()
    nonisolated(unsafe) var recordsToReturn: [DNSRecord]?
    nonisolated(unsafe) var errorToThrow: Error?
    
    func fetchDNSRecords() async throws -> [DNSRecord] {
        recordCall(withIdentifier: "fetchDNSRecords")
        if let errorToThrow { throw errorToThrow }
        return recordsToReturn ?? []
    }
    
    func updateDNSRecord(_ record: DNSRecord) async throws {
        recordCall(
            withIdentifier: "updateDNSRecord",
            arguments: [record.toString()]
        )
        if let errorToThrow { throw errorToThrow }
    }
    
    func createDNSRecord(_ record: DNSRecord) async throws {
        recordCall(withIdentifier: "createDNSRecord", arguments: [record])
    }

    func deleteDNSRecord(_ id: String?) async throws {
        recordCall(withIdentifier: "deleteDNSRecord", arguments: [id])
    }
    
}
