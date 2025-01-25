//
//  MockLogger.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation
import Mimus
@testable import CloudflareDNSUpdater

final class MockLogger: Logger, Mock {
    
    nonisolated(unsafe) var storage = Storage()
    
    func logMessage(message: String) {
        recordCall(withIdentifier: "logMessage", arguments: [message])
    }
    
}
