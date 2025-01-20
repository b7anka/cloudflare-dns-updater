//
//  CloudflareResponse.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

struct CloudflareResponse<T: Codable>: Codable {
    let success: Bool
    let errors: [CloudflareError]
    let result: T?
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CloudflareResponse<T>.CodingKeys> = try decoder.container(
            keyedBy: CloudflareResponse<T>.CodingKeys.self
        )
        self.success = try container
            .decodeIfPresent(
                Bool.self,
                forKey: CloudflareResponse<T>.CodingKeys.success
            ) ?? false
        self.errors = try container
            .decodeIfPresent(
                [CloudflareError].self,
                forKey: CloudflareResponse<T>.CodingKeys.errors
            ) ?? []
        self.result = try container
            .decodeIfPresent(
                T.self,
                forKey: CloudflareResponse<T>.CodingKeys.result
            )
    }
    
}
