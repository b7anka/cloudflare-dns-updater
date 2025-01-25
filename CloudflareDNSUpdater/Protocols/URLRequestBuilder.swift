//
//  URLRequestBuilder.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

protocol URLRequestBuilder: Sendable, AnyObject {
    func build(url: URL, headers: [HTTPHeader]?, body: Codable?, method: HTTPMethod) throws -> URLRequest
}
