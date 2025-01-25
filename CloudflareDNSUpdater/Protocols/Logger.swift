//
//  Logger.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 25/01/2025.
//

import Foundation

protocol Logger: Sendable, AnyObject {
    func logMessage(message: String)
}
