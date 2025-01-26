//
//  DefaultDNSRepositoryTests.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Quick
import Nimble
import Mimus
@testable import CloudflareDNSUpdater

class DefaultDNSRepositoryTests: QuickSpec {
    override static func spec() {
        describe("DefaultDNSRepository") {
            var sut: DefaultDNSRepository!
            var mockAPIClientFactory: MockAPIClientFactory!
            var mockAPIClient: MockAPIClient!
            var mockLogger: MockLogger!
            
            beforeEach {
                mockLogger = MockLogger()
                mockAPIClientFactory = MockAPIClientFactory()
                mockAPIClient = MockAPIClient()
                mockAPIClientFactory.clientToReturn = mockAPIClient
                sut = DefaultDNSRepository(
                    factory: mockAPIClientFactory,
                    zoneId: "test-zone",
                    apiToken: "test-token",
                    logger: mockLogger
                )
            }
            
            describe("fetchDNSRecords") {
                context("when the request succeeds") {
                    it("makes the correct API request") {
                        let expectedRecords = [
                            DNSRecord(id: "1", name: "test.com", content: "1.1.1.1"),
                            DNSRecord(id: "2", name: "test2.com", content: "2.2.2.2")
                        ]
                        let response = CloudflareResponse(result: expectedRecords)
                        mockAPIClient.responseToReturn = response
                        
                        waitUntil { done in
                            Task {
                                let records = try await sut.fetchDNSRecords()
                                expect(records) == expectedRecords
                                
                                mockAPIClientFactory
                                    .verifyCall(withIdentifier: "makeAPIClient")
                                
                                mockAPIClient
                                    .verifyCall(
                                        withIdentifier: "request",
                                        arguments: [
                                            HTTPMethod.get.rawValue,
                                            "https://api.cloudflare.com/client/v4/zones/test-zone/dns_records",
                                            nil,
                                            [
                                                "Authorization - Bearer test-token",
                                                "Content-Type - application/json"
                                            ]
                                        ]
                                    )
                                done()
                            }
                        }
                    }
                }
                
                context("when the request fails") {
                    it("propagates the error") {
                        let expectedError = NSError(domain: "test", code: 1)
                        mockAPIClient.errorToThrow = expectedError
                        
                        waitUntil { done in
                            Task {
                                do {
                                    _ = try await sut.fetchDNSRecords()
                                    fail("Expected error to be thrown")
                                } catch {
                                    expect(error).to(matchError(expectedError))
                                }
                                done()
                            }
                        }
                    }
                }
            }
            
            describe("updateDNSRecord") {
                
                context("when record ID is provided") {
                    it("makes the correct API request") {
                        let record = DNSRecord(id: "test-id", name: "test.com", content: "1.1.1.1")
                        let response = CloudflareResponse(result: record)
                        mockAPIClient.responseToReturn = response
                        
                        waitUntil { done in
                            Task {
                                try await sut.updateDNSRecord(record)
                                
                                mockAPIClient
                                    .verifyCall(
                                        withIdentifier: "request",
                                        arguments: [
                                            HTTPMethod.put.rawValue,
                                            "https://api.cloudflare.com/client/v4/zones/test-zone/dns_records/test-id",
                                            String(describing: record),
                                            [
                                                "Authorization - Bearer test-token",
                                                "Content-Type - application/json"
                                            ]
                                        ]
                                    )
                                done()
                            }
                        }
                    }
                }
                
                context("when record ID is missing") {
                    it("throws an error") {
                        waitUntil { done in
                            Task {
                                let record = DNSRecord(id: nil, name: "test.com", content: "1.1.1.1")
                                do {
                                    try await sut.updateDNSRecord(record)
                                } catch let error as RepositoryError {
                                    expect(error).to(equal(.idMissing))
                                } catch {
                                    fail("expected an error of type RepositoryError.idMissing, got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }
            }
            
            describe("createDNSRecord") {
                it("makes the correct API request") {
                    let record = DNSRecord(id: nil, name: "test.com", content: "1.1.1.1")
                    let response = CloudflareResponse(result: record)
                    mockAPIClient.responseToReturn = response
                    
                    waitUntil { done in
                        Task {
                            try await sut.createDNSRecord(record)
                            
                            mockAPIClient
                                .verifyCall(
                                    withIdentifier: "request",
                                    arguments: [
                                        HTTPMethod.post.rawValue,
                                        "https://api.cloudflare.com/client/v4/zones/test-zone/dns_records",
                                        String(describing: record),
                                        ["Authorization - Bearer test-token",
                                         "Content-Type - application/json"]
                                    ]
                                )
                            done()
                        }
                    }
                }
            }
            
            describe("deleteDNSRecord") {
                
                context("when record ID is provided") {
                    it("makes the correct API request") {
                        let recordId = "test-id"
                        let response = CloudflareResponse<DNSRecord>(result: nil)
                        mockAPIClient.responseToReturn = response
                        
                        waitUntil { done in
                            Task {
                                try await sut.deleteDNSRecord(recordId)
                                
                                mockAPIClient
                                    .verifyCall(
                                        withIdentifier: "request",
                                        arguments: [
                                            HTTPMethod.delete.rawValue,
                                            "https://api.cloudflare.com/client/v4/zones/test-zone/dns_records/test-id",
                                            nil,
                                            [
                                                "Authorization - Bearer test-token",
                                                "Content-Type - application/json"
                                            ]
                                        ]
                                    )
                                done()
                            }
                        }
                    }
                }
                
                context("when record ID is missing") {
                    
                    it("throws an error") {
                        waitUntil { done in
                            Task {
                                do {
                                    try await sut.deleteDNSRecord(nil)
                                } catch let error as RepositoryError {
                                    expect(error).to(equal(.idMissing))
                                } catch {
                                    fail("expected an error of type RepositoryError.idMissing, got \(error)")
                                }
                                done()
                            }
                        }
                    }
                }
            }
            
            describe("Deinitialization") {
                context("when deinit is calle") {
                    it("should log a message") {
                        sut = nil
                        mockLogger
                            .verifyCall(
                                withIdentifier: "logMessage",
                                arguments: [
                                    "DEFAULT DNS REPOSITORY DEINIT CALLED"
                                ]
                            )
                    }
                }
            }
        }
    }
}
