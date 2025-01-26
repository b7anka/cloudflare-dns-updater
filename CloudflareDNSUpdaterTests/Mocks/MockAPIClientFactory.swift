//
//  MockAPIClientFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockAPIClientFactory: APIClientFactory, Mock {
    
    var storage = Storage()
    var clientToReturn: APIClient?
    
    func makeAPIClient() -> APIClient {
        recordCall(withIdentifier: "makeAPIClient")
        return clientToReturn ?? MockAPIClient()
    }
    
}
