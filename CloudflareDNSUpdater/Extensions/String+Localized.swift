//
//  String+Localized.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

extension String {
    
    func localized() -> String {
        NSLocalizedString(self, value: "Missing localization", comment: "")
    }
    
}
