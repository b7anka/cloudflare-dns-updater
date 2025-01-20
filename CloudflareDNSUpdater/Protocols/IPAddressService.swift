//
//  IPAddressService.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

protocol IPAddressService: AnyObject {
    func getCurrentIPAddress() async throws -> String
}
