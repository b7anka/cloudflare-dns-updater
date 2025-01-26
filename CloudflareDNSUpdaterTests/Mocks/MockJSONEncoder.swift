//
//  MockJSONEncoder.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockJSONEncoder: JSONEncoderProtocol, Mock {
    
    nonisolated(unsafe) var storage = Storage()
    
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        recordCall(
            withIdentifier: "encode",
            arguments: [String(describing: T.self)]
        )
        return try JSONEncoder().encode(value)
    }
    
}
