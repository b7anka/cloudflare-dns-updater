//
//  WindowAccessor.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 18/01/2025.
//

import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    
    let mainQueue: DispatchQueueProtocol
    @ObservedObject var windowManager: WindowManager
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        mainQueue.async {
            if let window = view.window {
                windowManager.setMainWindow(window)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}

}
