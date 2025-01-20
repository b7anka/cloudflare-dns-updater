//
//  DefaultAPIClient.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

final class DefaultAPIClient: APIClientProtocol {
    
    private let requestBuilder: URLRequestBuilder
    private let session: URLSessionProtocol
    private let decoder: JSONDecoderProtocol
    
    init(
        requestBuilder: URLRequestBuilder,
        sessionFactory: URLSessionFactory,
        decoder: JSONDecoderProtocol
    ) {
        self.requestBuilder = requestBuilder
        session = sessionFactory.makeURLSession()
        self.decoder = decoder
    }
    
    func request<T: Codable>(_ method: HTTPMethod, url: String, body: Codable?, headers: [HTTPHeader]?) async throws -> T {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let request: URLRequest = try requestBuilder.build(
            url: url,
            headers: headers,
            body: body,
            method: method
        )
        
        let (data, response) = try await session.data(for: request, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
}