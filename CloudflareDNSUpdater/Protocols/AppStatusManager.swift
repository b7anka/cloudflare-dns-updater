//
//  AppStatusManager.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 27/01/2025.
//

import Foundation

@MainActor
protocol AppStatusManager: AnyObject {
    
    func showApp()
    func hideApp()
    func hideDockIcon()
    
}
