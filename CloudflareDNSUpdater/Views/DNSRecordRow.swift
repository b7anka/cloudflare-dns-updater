//
//  DNSRecordRow.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI

struct DNSRecordRow: View {
    let record: DNSRecord
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(record.nameOrNoValue)
                .font(.headline)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
#Preview {
    let record: DNSRecord = DNSRecord(
        id: "1",
        name: "example.com",
        type: "A",
        content: "example",
        proxied: false,
        ttl: 100
    )
    DNSRecordRow(record: record)
}
#endif
