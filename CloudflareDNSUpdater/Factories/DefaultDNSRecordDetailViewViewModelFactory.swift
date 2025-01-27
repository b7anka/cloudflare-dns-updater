//
//  DefaultDNSRecordDetailViewViewModelFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
// swiftlint:disable type_name
struct DefaultDNSRecordDetailViewViewModelFactory: DNSRecordDetailViewViewModelFactory {
    
    func makeViewModel(for record: DNSRecord, with appState: MainViewViewModel) -> DNSRecordDetailViewModel {
        let viewModel = DNSRecordDetailViewModel(
            record: record,
            persistenceManager: DefaultPersistenceManager.shared,
            repositoryFactory: DefaultDNSRepositoryFactory(),
            appState: appState,
            logger: DefaultLogger.shared
        )
        return viewModel
    }
    
}
