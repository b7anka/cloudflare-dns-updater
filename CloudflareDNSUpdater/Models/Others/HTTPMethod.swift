//
//  HTTPMethod.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

enum HTTPMethod: String, Identifiable, Equatable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var id: String { rawValue }
    
    static func == (lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
}
