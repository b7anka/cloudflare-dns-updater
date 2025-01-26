//
//  DefaultURLRequestBuilderSpec.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import Quick
import Nimble
import Mimus
@testable import CloudflareDNSUpdater

// swiftlint:disable force_try
final class DefaultURLRequestBuilderSpec: QuickSpec {
    override static func spec() {
        
        describe("DefaultURLRequestBuilder") {
            var sut: DefaultURLRequestBuilder!
            var mockEncoder: MockJSONEncoder!
            var logger: MockLogger!
            
            beforeEach {
                mockEncoder = MockJSONEncoder()
                logger = MockLogger()
                sut = DefaultURLRequestBuilder(
                    encoder: mockEncoder,
                    logger: logger
                )
            }
            
            context("when building a request") {
                var url: URL!
                var headers: [HTTPHeader]!
                var method: HTTPMethod!
                var request: URLRequest!
                
                beforeEach {
                    url = URL(string: "https://api.test.com")!
                    headers = [
                        HTTPHeader(key: "Content-Type", value: "application/json"),
                        HTTPHeader(key: "Authorization", value: "Bearer token")
                    ]
                    method = .post
                }
                
                context("with headers and body") {
                    var body: TestBody!
                    
                    beforeEach {
                        body = TestBody(id: "123", value: "test")
                        request = try! sut.build(url: url, headers: headers, body: body, method: method)
                    }
                    
                    it("should set the correct URL") {
                        expect(request.url?.absoluteString) == url.absoluteString
                    }
                    
                    it("should set the correct method") {
                        expect(request.httpMethod) == method.rawValue
                    }
                    
                    it("should set all headers") {
                        for header in headers {
                            expect(request.value(forHTTPHeaderField: header.key)) == header.value
                        }
                    }
                    
                    it("should encode the body") {
                        mockEncoder
                            .verifyCall(
                                withIdentifier: "encode",
                                arguments: [String(describing: TestBody.self)]
                            )
                    }
                }
                
                context("without headers") {
                    beforeEach {
                        request = try! sut.build(url: url, headers: nil, body: nil, method: method)
                    }
                    
                    it("should create a valid request without headers") {
                        expect(request.allHTTPHeaderFields).to(equal([:]))
                    }
                }
                
                context("without body") {
                    beforeEach {
                        request = try! sut.build(url: url, headers: headers, body: nil, method: method)
                    }
                    
                    it("should create a valid request without body") {
                        expect(request.httpBody).to(beNil())
                    }
                }
            }
            
            describe("Deinitialization") {
                context("when deinit is called") {
                    it("should log a message") {
                        sut = nil
                        logger
                            .verifyCall(
                                withIdentifier: "logMessage",
                                arguments: ["DEFAULT URL REQUEST BUILDER DEINIT CALLED"]
                            )
                    }
                }
            }
        }
    }
}

private struct TestBody: Codable {
    let id: String
    let value: String
}
