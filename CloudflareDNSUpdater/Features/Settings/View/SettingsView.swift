//
//  SettingsView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @AppStorage("cloudflareApiToken") private var apiToken = ""
    @AppStorage("cloudflareZoneId") private var zoneId = ""
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    
    var body: some View {
        Form {
            Section(header: Text("Cloudflare Settings")) {
                SecureField("API Token", text: $apiToken)
                TextField("Zone ID", text: $zoneId)
            }
            
            Section(header: Text("Application Settings")) {
                Toggle("Launch at Login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin, initial: launchAtLogin, { oldValue, newValue in
                        // Implement launch at login functionality
                    })
            }
        
        }
        .padding()
        .frame(width: 400, height: 300)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Close") {
                    dismiss()
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    SettingsView()
}
#endif
