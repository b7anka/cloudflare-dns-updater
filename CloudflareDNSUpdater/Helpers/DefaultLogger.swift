//
//  DefaultLogger.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation

final class DefaultLogger: Logger {
    
    static let shared = DefaultLogger()
    
    private init() {}
    
    func logMessage(message: String) {
        guard AppConfig.current == .debug else { return }
        print(message)
    }
    
}
