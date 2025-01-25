//
//  PersistenceError.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation

enum PersistenceError: LocalizedError {
    
    case contextNotFound
    
    var errorDescription: String? {
        switch self {
        case .contextNotFound:
            return "ModelContext not found"
        }
    }
    
}
