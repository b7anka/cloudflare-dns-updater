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

class DefaultAPIClientTests: QuickSpec {
    override static func spec() {
        var sut: DefaultAPIClient!
        var mockRequestBuilder: MockURLRequestBuilder!
        var mockSessionFactory: MockURLSessionFactory!
        var mockSession: MockURLSession!
        var mockDecoder: MockJSONDecoder!
        
        beforeEach {
            mockRequestBuilder = MockURLRequestBuilder()
            mockSessionFactory = MockURLSessionFactory()
            mockSession = mockSessionFactory.makeURLSession() as? MockURLSession
            mockDecoder = MockJSONDecoder()
            
            sut = DefaultAPIClient(
                requestBuilder: mockRequestBuilder,
                sessionFactory: mockSessionFactory,
                decoder: mockDecoder
            )
        }
        
        describe("request") {
            let testURL = "https://api.test.com"
            let testHeaders = [HTTPHeader(key: "Content-Type", value: "application/json")]
            let testBody = ["key": "value"]
            let testResponse = TestResponse(id: 1, name: "Test")
            
            context("when URL is invalid") {
                it("throws badURL error") {
                    waitUntil { done in
                        Task {
                            await expect {
                                try await sut.request(
                                    .get,
                                    url: "invalid url",
                                    body: nil,
                                    headers: nil
                                ) as TestResponse
                            }.to(throwError(URLError(.badURL)))
                            done()
                        }
                    }
                }
            }
            
            context("when request is successful") {
            
                it("builds request correctly") {
                    let method: HTTPMethod = .post
                    waitUntil { done in
                        Task {
                            _ = try? await sut.request(
                                method,
                                url: testURL,
                                body: testBody,
                                headers: testHeaders
                            ) as TestResponse
                            
                            mockRequestBuilder.verifyCall(
                                withIdentifier: "build",
                                arguments: [
                                    testURL,
                                    testBody,
                                    testHeaders,
                                    method.rawValue
                                ]
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
        }
    }
}

// MARK: - Test Helpers

struct TestResponse: Codable, Equatable {
    let id: Int
    let name: String
}

final class MockURLRequestBuilder: URLRequestBuilder, Mock {
    var storage = Storage()
    
    func build(url: URL, headers: [HTTPHeader]?, body: Codable?, method: HTTPMethod) throws -> URLRequest {
        recordCall(
            withIdentifier: "build",
            arguments: [url, headers, body, method.rawValue]
        )
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        if let body {
            let data = try JSONEncoder().encode(body)
            request.httpBody = data
        }
        return request
    }
}

final class MockURLSessionFactory: URLSessionFactory, Mock {
    var storage = Storage()
    
    func makeURLSession() -> URLSessionProtocol {
        recordCall(withIdentifier: "makeUrlSession")
        return MockURLSession()
    }
}

final class MockURLSession: URLSessionProtocol, Mock {
    
    var storage = Storage()
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (
        Data,
        URLResponse
    ) {
        recordCall(withIdentifier: "dataFromUrl", arguments: [url])
        return (Data(), URLResponse())
    }
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (
        Data,
        URLResponse
    ) {
        recordCall(withIdentifier: "dataForRequest", arguments: [request])
        return (Data(), URLResponse())
    }
    
}

final class MockJSONDecoder: JSONDecoderProtocol, Mock {
    
    var storage = Storage()
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        recordCall(withIdentifier: "decode", arguments: [type, data])
        return try decode(type.self, from: data)
    }
    
}
