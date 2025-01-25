//
//  MockIPAddressService.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockIPAddressService: IPAddressService, Mock {
    
    nonisolated(unsafe) var storage = Storage()
    nonisolated(unsafe) var ipToReturn: String?
    nonisolated(unsafe) var errorToThrow: Error?
    
    func getCurrentIPAddress() async throws -> String {
        recordCall(withIdentifier: "getCurrentIPAddress")
        if let errorToThrow { throw errorToThrow }
        return ipToReturn ?? "192.168.1.1"
    }
    
}
