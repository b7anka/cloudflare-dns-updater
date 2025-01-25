//
//  DefaultBackgroundTaskManagerSpec.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Quick
import Nimble
import Mimus
@testable import CloudflareDNSUpdater

// swiftlint:disable function_body_length
final class DefaultBackgroundTaskManagerSpec: QuickSpec {
    override static func spec() {
        var sut: DefaultBackgroundTaskManager!
        var mockIPService: MockIPAddressService!
        var mockDNSRepository: MockDNSRepository!
        var mockStorageManager: MockStorageManager!
        var mockPersistenceManager: MockPersistenceManager!
        var mockLogger: MockLogger!
        var mockFactory: MockDNSRepositoryFactory!
        var mockStorageFactory: MockStorageManagerFactory!
        
        beforeEach {
            mockIPService = MockIPAddressService()
            mockDNSRepository = MockDNSRepository()
            mockStorageManager = MockStorageManager()
            mockPersistenceManager = MockPersistenceManager()
            mockLogger = MockLogger()
            
            mockFactory = MockDNSRepositoryFactory()
            mockFactory.repositoryToReturn = mockDNSRepository
            
            mockStorageFactory = MockStorageManagerFactory()
            mockStorageFactory.storageToReturn = mockStorageManager
            
            sut = DefaultBackgroundTaskManager(
                interval: 1,
                ipAddressService: mockIPService,
                factory: mockFactory,
                storageFactory: mockStorageFactory,
                persistanceManager: mockPersistenceManager,
                logger: mockLogger
            )
        }
        
        describe("initialization") {
            it("should load last known IP from storage") {
                mockStorageManager.valueToReturn = "192.168.1.1"
                
                sut = DefaultBackgroundTaskManager(
                    interval: 1,
                    ipAddressService: mockIPService,
                    factory: mockFactory,
                    storageFactory: mockStorageFactory,
                    persistanceManager: mockPersistenceManager,
                    logger: mockLogger
                )
                
                expect(sut.currentIP) == "192.168.1.1"
                mockStorageManager
                    .verifyCall(withIdentifier: "string",
                                arguments: ["lastknownIpAddress"],
                                mode: .atLeast(1)
                    )
                mockStorageFactory
                    .verifyCall(
                        withIdentifier: "makeStorageManager",
                        mode: .times(2)
                    )
                mockFactory
                    .verifyCall(
                        withIdentifier: "makeDNSRepository",
                        mode: .times(2)
                    )
            }
        }
        
        describe("background task execution") {
            context("when IP hasn't changed") {
                beforeEach {
                    mockStorageManager.valueToReturn = "192.168.1.1"
                    mockIPService.ipToReturn = "192.168.1.1"
                }
                
                it("should not update DNS records") {
                    sut.startBackgroundTask()
                    
                    expect(sut.isUpdating).toEventually(beTrue())
                    
                    mockDNSRepository.verifyCall(
                        withIdentifier: "updateDNSRecord",
                        mode: .never
                    )
                    mockIPService.verifyCall(withIdentifier: "getCurrentIPAddress")
                    
                    expect(sut.lastUpdate).toEventually(beNil())
                    expect(sut.isUpdating).toEventually(beFalse())
                }
            }
            
            context("when IP has changed") {
                var dnsRecords: [DNSRecord]!
                var autoUpdateRecords: [AutoUpdateRecord]!
                
                beforeEach {
                    mockStorageManager.valueToReturn = "192.168.1.1"
                    mockIPService.ipToReturn = "192.168.1.2"
                    
                    let record1 = DNSRecord(
                        id: "1",
                        name: "test1.com",
                        type: "A",
                        content: "192.168.1.1",
                        proxied: true,
                        ttl: 1
                    )
                    let record2 = DNSRecord(
                        id: "2",
                        name: "test2.com",
                        type: "CNAME",
                        content: "192.168.1.1",
                        proxied: true,
                        ttl: 1
                    )
                    
                    dnsRecords = [
                        record1,
                        record2
                    ]
                    
                    autoUpdateRecords = [
                        AutoUpdateRecord(
                            recordId: record1.id!,
                            recordName: record1
                                .name!)
                    ]
                    
                    mockDNSRepository.recordsToReturn = dnsRecords
                    mockPersistenceManager.recordsToReturn = autoUpdateRecords
                }
                
                it(
                    "should update only A records that are marked for auto-update and should save new IP address"
                ) {
                    sut.startBackgroundTask()
                    
                    expect(sut.lastUpdate).toEventuallyNot(beNil())
                    expect(sut.currentIP) == "192.168.1.2"
                    mockDNSRepository
                        .verifyCall(
                            withIdentifier: "updateDNSRecord",
                            arguments: [
                                DNSRecord(
                                    id: "1",
                                    name: "test1.com",
                                    type: "A",
                                    content: "192.168.1.2",
                                    proxied: true,
                                    ttl: 1
                                ).toString()
                            ]
                        )
                    mockStorageManager
                        .verifyCall(withIdentifier: "set", arguments: [
                            sut.currentIP,
                            UserDefaultsKey.lastknownIpAddress.rawValue
                        ])
                    mockPersistenceManager
                        .verifyCall(
                            withIdentifier: "fetch",
                            arguments: [
                                String(describing: AutoUpdateRecord.self),
                                nil,
                                nil
                            ]
                        )
                }
            }
            
            context("when an error occurs") {
                beforeEach {
                    mockIPService.errorToThrow = NSError(
                        domain: "test",
                        code: -1
                    )
                }
                
                it("should store the error") {
                    sut.startBackgroundTask()
                    
                    expect(sut.lastError)
                        .toEventually(
                            matchError(NSError(domain: "test", code: -1))
                        )
                }
            }
        }
        
        describe("task management") {
            it("should stop background task when requested") {
                sut.startBackgroundTask()
                sut.stopBackgroundTask()
                
                mockIPService.ipToReturn = "192.168.1.2"
                mockIPService
                    .verifyCall(
                        withIdentifier: "getCurrentIPAddress",
                        mode: .never
                    )
            }
        }
        
        describe("Deinitialization") {
            context("when deinit is called") {
                it("should log message") {
                    sut = nil
                    mockLogger
                        .verifyCall(
                            withIdentifier: "logMessage",
                                    arguments: ["DEFAULT BACKGROUND TASK MANAGER DEINIT CALLED"]
                        )
                }
            }
        }
    }
}
