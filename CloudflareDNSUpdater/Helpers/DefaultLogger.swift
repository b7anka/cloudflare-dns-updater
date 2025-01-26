//
//  DefaultLogger.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation

final class DefaultLogger: Logger {
    
    static let shared = DefaultLogger()
    nonisolated(unsafe) private(set) var appConfig: AppConfig = .current
    
    private init() {}
    
    func logMessage(message: String) -> Bool {
        guard appConfig == .debug else { return false }
        print(message)
        return true
    }
    
}

#if DEBUG
// for testing pourposes only
extension DefaultLogger {
    func setAppConfig(_ appConfig: AppConfig) {
        self.appConfig = appConfig
    }
}
#endif
