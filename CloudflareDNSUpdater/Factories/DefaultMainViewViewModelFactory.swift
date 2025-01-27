//
//  DefaultMainViewViewModelFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 27/01/2025.
//

import Foundation

struct DefaultMainViewViewModelFactory: MainViewViewModelFactory {
    
    func makeMainViewViewModel() -> MainViewViewModel {
        let dnsRepositoryFactory = DefaultDNSRepositoryFactory()
        let viewModel: MainViewViewModel = MainViewViewModel(
            factory: dnsRepositoryFactory
        )
        return viewModel
    }
    
}
