//
//  SettingsView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SettingsViewViewModel
    
    init(
        viewModelFactory: SettingsViewViewModelFactory = DefaultSettingsViewViewModelFactory()
    ) {
        _viewModel = StateObject(wrappedValue: viewModelFactory.makeViewModel())
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            toolbar
            form
        }
        .frame(width: 400)
    }
    
    // MARK: - TOOLBAR
    @ViewBuilder private var toolbar: some View {
        TopToolBarView(buttons: [
            .close({ dismiss() })
        ], toolbarPadding: 10,
                       backgreoundColor: nil)
    }
    
    // MARK: - CLOUDFLARE SETTINGS SECTION
    @ViewBuilder private var cloudflareSettings: some View {
        Section(
            header: Text("settingsView_cloudflareSettings".localized())
        ) {
            SecureField(
                "settingsView_apiToken".localized(),
                text: $viewModel.apiToken
            )
            TextField("settingsView_zoneId".localized(), text: $viewModel.zoneId)
        }
    }
    
    // MARK: - APPLICATION SETTINGS SECTION
    @ViewBuilder private var applicationSettings: some View {
        Section(
            header: Text("settingsView_applicationSettings".localized())
        ) {
            Toggle(
                "settingsView_launchMinimized".localized(),
                isOn: $viewModel.startMinimized
            )
            Toggle(
                "settingsView_quitWhenClosed".localized(),
                isOn: $viewModel.quitWhenClosed
            )
        }
    }
    
    // MARK: - FORM
    @ViewBuilder private var form: some View {
        Form {
            cloudflareSettings
            applicationSettings
        }
        .padding()
    }
    
}

#if DEBUG
#Preview {
    SettingsView()
}
#endif
