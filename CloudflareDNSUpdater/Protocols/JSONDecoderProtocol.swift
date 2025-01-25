//
//  JSONDecoderProtocol.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

protocol JSONDecoderProtocol: Sendable, AnyObject {
    func decode<T>(
        _ type: T.Type,
        from data: Data
    ) throws -> T where T: Decodable
}
