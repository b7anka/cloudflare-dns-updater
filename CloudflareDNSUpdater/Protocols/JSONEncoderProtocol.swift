//
//  JSONEncoderProtocol.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

protocol JSONEncoderProtocol: Sendable, AnyObject {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}
