//
//  MockAPIClient.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

// swiftlint:disable force_cast
final class MockAPIClient: APIClient, Mock {
    
    nonisolated(unsafe) var storage = Storage()
    nonisolated(unsafe) var responseToReturn: Codable?
    nonisolated(unsafe) var errorToThrow: Error?
    
    func request<T>(_ method: HTTPMethod, url: String, body: Codable?, headers: [HTTPHeader]?) async throws -> T where T: Decodable {
        recordCall(
            withIdentifier: "request",
            arguments: [
                method.rawValue,
                url,
                body == nil ? nil : String(describing: body!),
                headers?.compactMap({ "\($0.key) - \($0.value)" })
            ]
        )
        if let errorToThrow { throw errorToThrow }
        return responseToReturn as! T
    }
    
}
