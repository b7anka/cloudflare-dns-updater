//
//  DefaultSettingsViewViewModelFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation

struct DefaultSettingsViewViewModelFactory: SettingsViewViewModelFactory {
    
    func makeViewModel() -> SettingsViewViewModel {
        let viewModel = SettingsViewViewModel(
            logger: DefaultLogger.shared,
            storageManagerFactory: DefaultStorageManagerFactory()
        )
        return viewModel
    }
    
}
