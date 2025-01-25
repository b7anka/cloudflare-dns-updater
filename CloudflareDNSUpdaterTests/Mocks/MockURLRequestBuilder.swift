//
//  MockURLRequestBuilder.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockURLRequestBuilder: URLRequestBuilder, Mock {
    var storage = Storage()
    
    func build(url: URL, headers: [HTTPHeader]?, body: Codable?, method: HTTPMethod) throws -> URLRequest {
        recordCall(
            withIdentifier: "build",
            arguments: [url.absoluteString, headers?.compactMap({ $0.key + ":" + $0.value}), body, method.rawValue]
        )
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        if let body {
            let data = try JSONEncoder().encode(body)
            request.httpBody = data
        }
        return request
    }
}
