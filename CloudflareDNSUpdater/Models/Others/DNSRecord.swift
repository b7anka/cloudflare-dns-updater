//
//  DNSRecord.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

struct DNSRecord: Codable, Identifiable, Equatable {
    
    let id: String?
    let name: String?
    let type: String?
    let content: String?
    let proxied: Bool
    var ttl: Int?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.content = try container
            .decodeIfPresent(String.self, forKey: .content)
        self.proxied = try container
            .decodeIfPresent(Bool.self, forKey: .proxied) ?? false
        self.ttl = try container.decodeIfPresent(Int.self, forKey: .ttl)
    }
    
    init(
        id: String?,
        name: String?,
        type: String? = nil,
        content: String?,
        proxied: Bool = false,
        ttl: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.content = content
        self.proxied = proxied
        self.ttl = ttl
    }
    
    func toString() -> String {
        return "\(nameOrNoValue) (\(typeOrNoValue)): \(contentOrNoValue)"
    }
    
}
