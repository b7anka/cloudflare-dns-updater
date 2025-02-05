//
//  DefaultIPAddressService.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

final class DefaultIPAddressService: IPAddressService {
    
    private let ipProviders = [
        "https://api.ipify.org",
        "https://api.my-ip.io/ip",
        "https://checkip.amazonaws.com"
    ]
    
    private nonisolated let session: URLSessionProtocol
    private let logger: Logger
    
    init(
        sessionFactory: URLSessionFactory = DefaultURLSessionFactory(),
        logger: Logger = DefaultLogger.shared
    ) {
        session = sessionFactory.makeURLSession()
        self.logger = logger
    }
    
    deinit {
        logger.logMessage(message: "DEFAULT IP ADDRESS SERVICE DEINIT CALLED")
    }
    
    func getCurrentIPAddress() async throws -> String {
        for provider in ipProviders {
            if let ipAddress = try? await fetchIP(from: provider) {
                return ipAddress
            }
        }
        throw IPError.networkError
    }
    
    private func fetchIP(from provider: String) async throws -> String {
        guard let url = URL(string: provider) else {
            throw IPError.invalidResponse
        }
        
        let (data, _) = try await session.data(from: url, delegate: nil)
        
        guard let ipAddress = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
              !ipAddress.isEmpty else {
            throw IPError.invalidResponse
        }
        
        return ipAddress
    }
}
