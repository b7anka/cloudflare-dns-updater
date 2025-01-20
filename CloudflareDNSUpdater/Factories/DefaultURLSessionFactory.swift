//
//  URLSessionFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

struct DefaultURLSessionFactory: URLSessionFactory {
    
    func makeURLSession() -> URLSessionProtocol {
        return URLSession.shared
    }
    
}
