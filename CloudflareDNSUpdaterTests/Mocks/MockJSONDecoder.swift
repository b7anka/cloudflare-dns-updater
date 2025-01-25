//
//  MockJSONDecoder.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockJSONDecoder: JSONDecoderProtocol, Mock {
    
    var storage = Storage()
    private(set) var lastData: Data?
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        recordCall(withIdentifier: "decode", arguments: [data])
        lastData = data
        return try JSONDecoder().decode(type.self, from: data)
    }
    
}
