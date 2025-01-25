//
//  AppConfig.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation

enum AppConfig {
    
    case debug
    case release
    
    static var current: AppConfig {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
    
}
