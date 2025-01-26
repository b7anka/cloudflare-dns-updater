//
//  APIClientFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

protocol APIClientFactory {
    func makeAPIClient() -> APIClient
}
