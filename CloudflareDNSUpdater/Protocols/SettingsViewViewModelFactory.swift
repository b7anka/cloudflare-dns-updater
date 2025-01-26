//
//  SettingsViewViewModelFactory.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation

protocol SettingsViewViewModelFactory {
    func makeViewModel() -> SettingsViewViewModel
}
