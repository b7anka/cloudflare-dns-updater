//
//  AppEnvironment.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation

enum AppEnvironment {
    
    case dev
    case prod
    
    static var current: AppEnvironment {
        #if DEV
        return .dev
        #else
        return .prod
        #endif
    }
    
}
