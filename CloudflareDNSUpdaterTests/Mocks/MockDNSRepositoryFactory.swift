//
//  MockDNSRepositoryFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockDNSRepositoryFactory: DNSRepositoryFactory, Mock {
    
    var storage = Storage()
    var repositoryToReturn: DNSRepositoryProtocol?
    
    func makeDNSRepository() -> DNSRepositoryProtocol {
        recordCall(withIdentifier: "makeDNSRepository")
        return repositoryToReturn ?? MockDNSRepository()
    }
    
}
