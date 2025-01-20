//
//  AppMainButton.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI


struct AppMainButton: View {
    
    let title: String
    let action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }

    }
    
}

#if DEBUG
#Preview {
    AppMainButton(title: "Save", action: {})
}
#endif
