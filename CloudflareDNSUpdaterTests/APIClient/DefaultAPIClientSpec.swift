//
//  DefaultAPIClientSpec.swift
//  CloudflareDNSUpdaterTests
//
//  Created by João Moreira on 23/01/2025.
//

import Foundation
import Quick
import Nimble
import Mimus
@testable import CloudflareDNSUpdater

class DefaultAPIClientSpec: QuickSpec {
    override static func spec() {
        var sut: DefaultAPIClient!
        var mockRequestBuilder: MockURLRequestBuilder!
        var mockSessionFactory: MockURLSessionFactory!
        var mockSession: MockURLSession!
        var mockDecoder: MockJSONDecoder!
        var mockLogger: MockLogger!
        
        beforeEach {
            mockLogger = MockLogger()
            mockRequestBuilder = MockURLRequestBuilder()
            mockSessionFactory = MockURLSessionFactory()
            mockSession = mockSessionFactory.makeURLSession() as? MockURLSession
            mockDecoder = MockJSONDecoder()
            
            sut = DefaultAPIClient(
                requestBuilder: mockRequestBuilder,
                sessionFactory: mockSessionFactory,
                decoder: mockDecoder,
                logger: mockLogger
            )
        }
        
        describe("request") {
            let testURL = "https://api.test.com"
            let testHeaders = [HTTPHeader(key: "Content-Type", value: "application/json")]
            let testBody = ["key": "value"]
            let testResponse = TestResponse(id: 1, name: "Test")
            
            context("when URL is invalid") {
                
                beforeEach {
                    mockSession.errorToThrow = URLError(.badURL)
                }
                
                it("throws badURL error") {
                    waitUntil { done in
                        Task {
                            do {
                                _ = try await sut.request(
                                    .get,
                                    url: "invalid url",
                                    body: nil,
                                    headers: nil
                                ) as TestResponse
                                fail("expected to throw error but didn't")
                            } catch let error as URLError {
                                expect(error.code).to(equal(.badURL))
                            } catch {
                                fail(
                                    "expected an error of type URLError but got \(error.localizedDescription)"
                                )
                            }
                            done()
                        }
                    }
                }
            }
            
            context("when request is successful") {
                
                beforeEach {
                    mockSession.responseToReturn = testResponse
                }
                
                it("builds request correctly") {
                    let method: HTTPMethod = .post
                    waitUntil { done in
                        Task {
                            _ = try await sut.request(
                                method,
                                url: testURL,
                                body: testBody,
                                headers: testHeaders
                            ) as TestResponse
                            
                            mockRequestBuilder.verifyCall(
                                withIdentifier: "build",
                                arguments: [
                                    testURL,
                                    testHeaders.compactMap({ $0.key + ":" + $0.value}),
                                    testBody,
                                    method.rawValue
                                ]
                            )
                            mockSessionFactory
                                .verifyCall(
                                    withIdentifier: "makeUrlSession",
                                    arguments: .none,
                                    mode: .atLeast(1)
                                )
                            done()
                        }
                    }
                }
                
                it("returns decoded response") {
                    waitUntil { done in
                        Task {
                            let result: TestResponse = try await sut.request(
                                .get,
                                url: testURL,
                                body: nil,
                                headers: nil
                            )
                            
                            mockDecoder
                                .verifyCall(
                                    withIdentifier: "decode",
                                    arguments: [
                                        mockDecoder.lastData
                                    ]
                                )
                            mockSession
                                .verifyCall(
                                    withIdentifier: "dataForRequest",
                                    arguments: [mockSession.lastRequest]
                                )
                            expect(result).to(equal(testResponse))
                            done()
                        }
                    }
                }
            }
            
            context("when response is not HTTPURLResponse") {
                
                it("throws badServerResponse error") {
                    waitUntil { done in
                        Task {
                            await expect {
                                try await sut.request(
                                    .get,
                                    url: testURL,
                                    body: nil,
                                    headers: nil
                                ) as TestResponse
                            }.to(throwError(URLError(.badServerResponse)))
                            done()
                        }
                    }
                }
            }
            
            context("when status code is not 2xx") {
                
                it("throws badServerResponse error") {
                    waitUntil { done in
                        Task {
                            await expect {
                                try await sut.request(
                                    .get,
                                    url: testURL,
                                    body: nil,
                                    headers: nil
                                ) as TestResponse
                            }.to(throwError(URLError(.badServerResponse)))
                            done()
                        }
                    }
                }
            }
            
            context("When deinit called") {
                it("should log message") {
                    sut = nil
                    mockLogger
                        .verifyCall(withIdentifier: "logMessage", arguments: ["DEFAULT API CLIENT DEINIT CALLED"])
                }
            }
        }
    }
}

// MARK: - Test Helpers

struct TestResponse: Codable, Equatable {
    let id: Int
    let name: String
}
