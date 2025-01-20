//
//  CloudflareError.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

struct CloudflareError: Codable {
    let code: Int?
    let message: String?
}
