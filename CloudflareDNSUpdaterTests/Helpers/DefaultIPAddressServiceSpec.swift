//
//  DefaultIPAddressServiceSpec.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Quick
import Nimble
import Mimus
@testable import CloudflareDNSUpdater

final class DefaultIPAddressServiceSpec: QuickSpec {
    override static func spec() {
        var sut: DefaultIPAddressService!
        var urlSession: MockURLSession!
        var urlSessionFactory: MockURLSessionFactory!
        var logger: MockLogger!
        
        beforeEach {
            urlSessionFactory = MockURLSessionFactory()
            urlSession = urlSessionFactory.makeURLSession() as? MockURLSession
            logger = MockLogger()
            sut = DefaultIPAddressService(
                sessionFactory: urlSessionFactory,
                logger: logger
            )
        }
        
        describe("getCurrentIPAddress") {
            context("when request succeeds") {
                it("returns the IP address from the response") {
                    waitUntil { done in
                        Task {
                            let ipString: String = "1.2.3.4"
                            urlSession.responseToReturn = nil
                            urlSession.stringToReturn = ipString
                            
                            await expect {
                                try await sut.getCurrentIPAddress()
                            } == "1.2.3.4"
                            urlSession
                                .verifyCall(
                                    withIdentifier: "dataFromUrl",
                                    arguments: ["https://api.ipify.org"],
                                    mode: .times(1)
                                )
                            urlSessionFactory
                                .verifyCall(
                                    withIdentifier: "makeUrlSession",
                                    mode: .times(2)
                                )
                            done()
                        }
                    }
                }
            }
            
            context("when request fails") {
                it("throws the error") {
                    waitUntil { done in
                        Task {
                            urlSession.stringToReturn = nil
                            urlSession.responseToReturn = nil
                            struct TestError: Error {}
                            urlSession.errorToThrow = TestError()
                            
                            await expect { try await sut.getCurrentIPAddress() }.to(throwError())
                            urlSession
                                .verifyCall(
                                    withIdentifier: "dataFromUrl",
                                    arguments: ["https://api.ipify.org"],
                                    mode: .times(1)
                                )
                            done()
                        }
                    }
                }
            }
            
            context("when response is invalid") {
                it("throws decodingError") {
                    waitUntil { done in
                        Task {
                            let error = URLError(
                                .cannotDecodeRawData
                            )
                            urlSession.responseToReturn = nil
                            urlSession.stringToReturn = nil
                            urlSession.errorToThrow = error
                            
                            await expect { try await sut.getCurrentIPAddress() }
                                .to(throwError(IPError.networkError))
                            urlSession
                                .verifyCall(
                                    withIdentifier: "dataFromUrl",
                                    arguments: ["https://api.my-ip.io/ip"],
                                    mode: .times(1)
                                )
                            urlSession
                                .verifyCall(
                                    withIdentifier: "dataFromUrl",
                                    arguments: ["https://checkip.amazonaws.com"],
                                    mode: .times(1)
                                )
                            done()
                        }
                    }
                }
            }
            
            describe("Deinitialization") {
                context("when the init is called") {
                    it("should log a message") {
                        sut = nil
                        logger
                            .verifyCall(
                                withIdentifier: "logMessage",
                                arguments: ["DEFAULT IP ADDRESS SERVICE DEINIT CALLED"]
                            )
                    }
                }
            }
        }
    }
}
