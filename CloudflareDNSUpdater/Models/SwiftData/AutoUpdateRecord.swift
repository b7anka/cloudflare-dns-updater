//
//  AutoUpdateRecord.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftData

@Model
final class AutoUpdateRecord {
    
    var recordId: String
    var recordName: String
    
    init(recordId: String, recordName: String) {
        self.recordId = recordId
        self.recordName = recordName
    }
    
}
