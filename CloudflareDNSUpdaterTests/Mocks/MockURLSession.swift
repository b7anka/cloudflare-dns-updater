//
//  MockURLSession.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockURLSession: URLSessionProtocol, Mock {
    
    var storage = Storage()
    var responseToReturn: Codable?
    var errorToThrow: Error?
    private(set) var lastRequest: URLRequest?
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (
        Data,
        URLResponse
    ) {
        recordCall(withIdentifier: "dataFromUrl", arguments: [url])
        if let responseToReturn {
            return try returnResponseData(response: responseToReturn, url: url)
        }
        if let errorToThrow {
            try throwError(errorToThrow)
        }
        return (Data(), URLResponse())
    }
    
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (
        Data,
        URLResponse
    ) {
        recordCall(withIdentifier: "dataForRequest", arguments: [request])
        lastRequest = request
        if let responseToReturn, let url = request.url {
            return try returnResponseData(
                response: responseToReturn,
                url: url)
        }
        if let errorToThrow {
            try throwError(errorToThrow)
        }
        return (Data(), URLResponse())
    }
    
    private func returnResponseData(response: Codable, url: URL) throws -> (Data, URLResponse) {
        let data = try JSONEncoder().encode(response)
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return (data, response)
    }
    
    private func throwError(_ error: Error) throws {
        throw error
    }
    
}