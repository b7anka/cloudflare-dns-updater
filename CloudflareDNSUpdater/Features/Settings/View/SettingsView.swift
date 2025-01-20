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
            Section(
                header: Text("settingsView_cloudflareSettings".localized())
            ) {
                SecureField(
                    "settingsView_apiToken".localized(),
                    text: $apiToken
                )
                TextField("settingsView_zoneId".localized(), text: $zoneId)
            }
            
            Section(
                header: Text("settingsView_applicationSettings".localized())
            ) {
                Toggle(
                    "settingsView_launchAtLogin".localized(),
                    isOn: $launchAtLogin
                )
            }
        
        }
        .padding()
        .frame(width: 400, height: 300)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("general_closeButton".localized()) {
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
