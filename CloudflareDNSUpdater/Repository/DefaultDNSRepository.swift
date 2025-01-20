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
    private let apiClient: APIClientProtocol
    private let zoneId: String
    private var headers: [HTTPHeader]
    
    init(factory: APIClientFactory, zoneId: String, apiToken: String) {
        self.apiClient = factory.makeAPIClient()
        self.zoneId = zoneId
        self.apiToken = apiToken
        self.headers = []
        createHeaders()
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
            fatalError("Record ID must be a string")
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
            fatalError("ID must be a string")
        }
        let endpoint = "\(baseURL)/zones/\(zoneId)/dns_records/\(id)"
        let _: CloudflareResponse<DNSRecord> = try await apiClient.request(
            .delete,
            url: endpoint,
            body: nil,
            headers: headers
        )
    }
    
    private func createHeaders() {
        let bearerTokenHeader: HTTPHeader = .init(key: "Authorization", value: "Bearer \(apiToken)")
        let applicationJsonHeader: HTTPHeader = .init(key: "Content-Type", value: "application/json")
        headers = [bearerTokenHeader, applicationJsonHeader]
    }
    
}
