//
//  HTTPHeader.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

struct HTTPHeader {
    
    let key: String
    let value: String
    
}

extension HTTPHeader: Equatable {
    
    static func == (lhs: HTTPHeader, rhs: HTTPHeader) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
    
}
