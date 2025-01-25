//
//  MockURLSessionFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockURLSessionFactory: URLSessionFactory, Mock {
    var storage = Storage()
    
    let session: MockURLSession = MockURLSession()
    
    func makeURLSession() -> URLSessionProtocol {
        recordCall(withIdentifier: "makeUrlSession")
        return session
    }
}
