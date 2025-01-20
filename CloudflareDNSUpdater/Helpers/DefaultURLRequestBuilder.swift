//
//  DefaultURLRequestBuilder.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

final class DefaultURLRequestBuilder: URLRequestBuilder {
    
    private let encoder: JSONEncoderProtocol
    
    init(encoder: JSONEncoderProtocol = JSONEncoder()) {
        self.encoder = encoder
    }
    
    func build(url: URL, headers: [HTTPHeader]?, body: Codable?, method: HTTPMethod) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }
        
        return request
    }
    
}
