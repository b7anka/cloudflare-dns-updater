//
//  OS.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation

// swiftlint:disable type_name
enum OS {
    
    case macOS
    case iOS
    case watchOS
    
    static var current: OS {
        #if os(macOS)
        return .macOS
        #elseif os(iOS)
        return .iOS
        #else
        return .watchOS
        #endif
    }
    
}
