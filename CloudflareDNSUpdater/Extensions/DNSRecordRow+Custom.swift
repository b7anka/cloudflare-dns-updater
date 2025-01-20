//
//  DNSRecordRow+Custom.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

extension DNSRecord {
    
    var nameOrNoValue: String {
        name ?? "-"
    }
    
    var typeOrNoValue: String {
        type ?? "-"
    }
    
    var contentOrNoValue: String {
        content ?? "-"
    }
    
    var ttlOrNoValue: String {
        if let ttl {
            return String(ttl)
        }
        return "-"
    }
    
}
