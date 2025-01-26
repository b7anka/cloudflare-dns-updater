//
//  DefaultDNSRepository.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

final class DefaultDNSRepository: DNSRepositoryProtocol {
    
    private let baseURL = "https://api.cloudflare.com/client/v4"
    private let apiToken: String
    private nonisolated let apiClient: APIClient
    private let logger: Logger
    private let zoneId: String
    private let headers: [HTTPHeader]
    
    init(factory: APIClientFactory, zoneId: String, apiToken: String, logger: Logger) {
        let bearerTokenHeader: HTTPHeader = .init(key: "Authorization", value: "Bearer \(apiToken)")
        let applicationJsonHeader: HTTPHeader = .init(key: "Content-Type", value: "application/json")
        self.apiClient = factory.makeAPIClient()
        self.zoneId = zoneId
        self.apiToken = apiToken
        self.logger = logger
        self.headers = [bearerTokenHeader, applicationJsonHeader]
    }
    
    deinit {
        logger.logMessage(message: "DEFAULT DNS REPOSITORY DEINIT CALLED")
    }
    
    func fetchDNSRecords() async throws -> [DNSRecord] {
        let endpoint = "\(baseURL)/zones/\(zoneId)/dns_records"
        let response: CloudflareResponse<[DNSRecord]> = try await apiClient.request(
            .get,
            url: endpoint,
            body: nil,
            headers: headers
        )
        return response.result ?? []
    }
    
    func updateDNSRecord(_ record: DNSRecord) async throws {
        guard let recordId = record.id else {
            throw RepositoryError.idMissing
        }
        let endpoint = "\(baseURL)/zones/\(zoneId)/dns_records/\(recordId)"
        let _: CloudflareResponse<DNSRecord> = try await apiClient.request(
            .put,
            url: endpoint,
            body: record,
            headers: headers
        )
    }
    
    func createDNSRecord(_ record: DNSRecord) async throws {
        let endpoint = "\(baseURL)/zones/\(zoneId)/dns_records"
        let _: CloudflareResponse<DNSRecord> = try await apiClient.request(
            .post,
            url: endpoint,
            body: record,
            headers: headers
        )
    }
    
    func deleteDNSRecord(_ id: String?) async throws {
        guard let id else {
            throw RepositoryError.idMissing
        }
        let endpoint = "\(baseURL)/zones/\(zoneId)/dns_records/\(id)"
        let _: CloudflareResponse<DNSRecord> = try await apiClient.request(
            .delete,
            url: endpoint,
            body: nil,
            headers: headers
        )
    }
    
}
