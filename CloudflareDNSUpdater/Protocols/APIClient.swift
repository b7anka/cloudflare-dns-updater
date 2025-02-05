//
//  APIClient.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

protocol APIClient: Sendable, AnyObject {
    func request<T: Codable>(_ method: HTTPMethod, url: String, body: Codable?, headers: [HTTPHeader]?) async throws -> T
}
