//
//  DefaultURLRequestBuilder.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

final class DefaultURLRequestBuilder: URLRequestBuilder {
    
    private let encoder: JSONEncoderProtocol
    private let logger: Logger
    
    init(
        encoder: JSONEncoderProtocol = JSONEncoder(),
        logger: Logger = DefaultLogger.shared
    ) {
        self.encoder = encoder
        self.logger = logger
    }
    
    deinit {
        logger.logMessage(message: "DEFAULT URL REQUEST BUILDER DEINIT CALLED")
    }
    
    func build(url: URL, headers: [HTTPHeader]?, body: Codable?, method: HTTPMethod) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if let body {
            request.httpBody = try encoder.encode(body)
        }
        
        return request
    }
    
}
