//
//  DefaultDNSRepositoryFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 19/01/2025.
//

import Foundation

struct DefaultDNSRepositoryFactory: DNSRepositoryFactory {
    
    func makeDNSRepository() -> DNSRepositoryProtocol {
        let clientFactory = DefaultAPIClientFactory()
        let storageManagerFactory = DefaultStorageManagerFactory()
        let storageManager = storageManagerFactory.makeStorageManager()
        return DefaultDNSRepository(
            factory: clientFactory,
            zoneId: storageManager.string(forKey: .cloudflareZoneId) ?? "",
            apiToken: storageManager.string(forKey: .cloudflareApiToken) ?? "",
            logger: DefaultLogger.shared
        )
    }
    
}
