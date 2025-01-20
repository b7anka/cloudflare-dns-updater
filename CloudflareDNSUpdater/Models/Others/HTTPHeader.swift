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
    
    func toKeyValuePair() -> (key: String, value: String) {
        return (key, value)
    }
    
}
