//
//  BackgroundTaskManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import Foundation

@MainActor
protocol BackgroundTaskManager: AnyObject {
    func startBackgroundTask()
    func stopBackgroundTask()
}
