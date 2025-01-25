//
//  DeviceType.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

enum DeviceType: String {
    
    case mac
    case iPhone
    case iPad
    case watch
    
    static var current: DeviceType {
        switch OS.current {
        #if os(iOS)
        case .iOS:
            if UIDevice.current.userInterfaceIdiom == .pad {
                return .iPad
            }
            return .iPhone
        #endif
        case .macOS:
            return .mac
        default:
            return .watch
        }
    }
    
}
