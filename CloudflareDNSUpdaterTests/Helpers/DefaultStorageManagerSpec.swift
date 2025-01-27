//
//  DefaultStorageManagerSpec.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import XCTest
import Quick
import Mimus
import Nimble
@testable import CloudflareDNSUpdater

final class DefaultStorageManagerSpec: QuickSpec {
    override static func spec() {
        
        var sut: DefaultStorageManager!
        var userDefaultsFactory: MockUserDefaultsFactory!
        var userDefaults: MockUserDefaults!
        var queue: MockDispatchQueue!
        var logger: MockLogger!
        
        beforeEach {
            userDefaultsFactory = MockUserDefaultsFactory()
            userDefaults = MockUserDefaults()
            userDefaultsFactory.userDefaultsToReturn = userDefaults
            queue = MockDispatchQueue()
            logger = MockLogger()
            
            sut = DefaultStorageManager(
                userDefaultsFactory: userDefaultsFactory,
                queue: queue,
                logger: logger
            )
        }
        
        describe("string(forKey:)") {
            context("when value exists") {
                beforeEach {
                    userDefaults.valueToReturn = "test-value"
                }
                
                it("returns the string value") {
                    let result = sut.string(forKey: .cloudflareApiToken)
                    expect(result).to(equal("test-value"))
                }
                
                it("uses sync queue") {
                    _ = sut.string(forKey: .cloudflareApiToken)
                    queue.verifyCall(withIdentifier: "syncThrowing")
                }
                
                it("calls userDefaults with correct key") {
                    _ = sut.string(forKey: .cloudflareApiToken)
                    userDefaults
                        .verifyCall(withIdentifier: "string", arguments: [UserDefaultsKey.cloudflareApiToken.rawValue])
                }
            }
            
            context("when value doesn't exist") {
                beforeEach {
                    userDefaults.valueToReturn = nil
                }
                
                it("returns nil") {
                    let result = sut.string(forKey: .cloudflareApiToken)
                    expect(result).to(beNil())
                }
            }
        }
        
        describe("bool(forKey:)") {
            context("when value exists") {
                beforeEach {
                    userDefaults.valueToReturn = true
                }
                
                it("returns the boolean value") {
                    let result = sut.bool(forKey: .launchMinimized)
                    expect(result).to(beTrue())
                }
                
                it("uses sync queue") {
                    _ = sut.bool(forKey: .launchMinimized)
                    queue.verifyCall(withIdentifier: "syncThrowing")
                }
                
                it("calls userDefaults with correct key") {
                    _ = sut.bool(forKey: .launchMinimized)
                    userDefaults
                        .verifyCall(withIdentifier: "bool", arguments: [UserDefaultsKey.launchMinimized.rawValue])
                }
            }
            
            context("when value doesn't exist") {
                beforeEach {
                    userDefaults.valueToReturn = nil
                }
                
                it("returns false") {
                    let result = sut.bool(forKey: .launchMinimized)
                    expect(result).to(beFalse())
                }
            }
        }
        
        describe("set(_:forKey:)") {
            it("uses sync queue") {
                sut.set("test-value", forKey: .cloudflareApiToken)
                queue.verifyCall(withIdentifier: "syncThrowing")
            }
            
            it("calls userDefaults with correct key and value") {
                sut.set("test-value", forKey: .cloudflareApiToken)
                userDefaults
                    .verifyCall(
                        withIdentifier: "setValue",
                        arguments: ["test-value", UserDefaultsKey.cloudflareApiToken.rawValue]
                    )
            }
        }
        
        describe("concurrent access") {
            it("handles multiple threads safely") {
                let expectation = XCTestExpectation(
                    description: "Concurrent operations"
                )
                expectation.expectedFulfillmentCount = 100
                
                DispatchQueue.concurrentPerform(iterations: 100) { _ in
                    sut.set("test-value", forKey: .cloudflareApiToken)
                    _ = sut.string(forKey: .cloudflareApiToken)
                    expectation.fulfill()
                }
                
                XCTWaiter().wait(for: [expectation], timeout: 5.0)
                queue.verifyCall(
                    withIdentifier: "syncThrowing",
                    mode: .times(200)
                )
            }
        }
        
        describe("deinitialization") {
            it("logs message when deinit is called") {
                sut = nil
                logger.verifyCall(withIdentifier: "logMessage", arguments: ["DEFAULT STORAGE MANAGER DEINIT CALLED"])
            }
        }
    }
}
