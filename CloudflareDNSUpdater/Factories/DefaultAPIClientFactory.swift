//
//  DefaultAPIClientFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

struct DefaultAPIClientFactory: APIClientFactory {
    
    func makeAPIClient() -> APIClient {
        let requestBuilder: URLRequestBuilder = DefaultURLRequestBuilder()
        let sessionFactory: URLSessionFactory = DefaultURLSessionFactory()
        let decoder: JSONDecoderProtocol = JSONDecoder()
        return DefaultAPIClient(
            requestBuilder: requestBuilder,
            sessionFactory: sessionFactory,
            decoder: decoder,
            logger: DefaultLogger.shared
        )
    }
    
}
