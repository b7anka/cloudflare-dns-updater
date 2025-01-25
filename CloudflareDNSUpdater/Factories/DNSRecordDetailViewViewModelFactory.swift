//
//  DNSRecordDetailViewViewModelFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation

@MainActor
protocol DNSRecordDetailViewViewModelFactory {
    
    func makeViewModel(for record: DNSRecord, with appState: AppState) -> DNSRecordDetailViewModel
    
}
