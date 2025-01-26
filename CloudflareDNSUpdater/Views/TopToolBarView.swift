//
//  TopToolBarView.swift
//  CloudflareDNSUpdater
//
//  Created by João Moreira on 26/01/2025.
//

import Foundation
import SwiftUI

typealias VoidAction = () -> Void

enum ToolBarButtonType: Identifiable, Hashable {
    
    case close(VoidAction)
    case minimize(VoidAction?)
    case maximize(VoidAction?)
    
    var id: Int {
        switch self {
        case .close:
            return 0
        case .minimize:
            return 1
        case .maximize:
            return 2
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ToolBarButtonType, rhs: ToolBarButtonType) -> Bool {
        lhs.id == rhs.id
    }
    
}

struct TopToolBarView: View {
    
    @State private var isHovered: Bool = false
    var buttons: [ToolBarButtonType]
    var toolbarPadding: CGFloat = 20
    var backgreoundColor: Color? = Color(NSColor.windowBackgroundColor)
    var borderColor: Color = Color(NSColor.separatorColor)
    
    var body: some View {
        HStack(spacing: .zero) {
            buttonsRow(types: buttons)
                .onHover { hovering in
                    isHovered = hovering
                }
            Spacer()
        }
        .padding(toolbarPadding)
        .background(backgreoundColor)
        .border(borderColor, width: 1)
    }
    
    @ViewBuilder private func button(for type: ToolBarButtonType) -> some View {
        Circle()
            .fill(colorForButton(type: type))
            .frame(width: 12, height: 12)
            .overlay(
                imageForButton(type: type)
                    .font(.system(size: 8))
                    .foregroundStyle(Color.black)
                    .opacity(isHovered ? 1 : 0)
            )
            .onTapGesture {
                switch type {
                case .close(let action):
                    action()
                case .minimize(let action):
                    action?()
                case .maximize(let action):
                    action?()
                }
            }
    }
    
    @ViewBuilder private func imageForButton(type: ToolBarButtonType) -> some View {
        switch type {
        case .close:
            Image(systemName: "xmark")
        case .minimize:
            Image(systemName: "minus")
        case .maximize:
            Image(systemName: "arrow.up.left.and.arrow.down.right")
        }
    }
    
    private func colorForButton(type: ToolBarButtonType) -> Color {
        switch type {
        case .close:
            Color.red
        case .minimize:
            Color.yellow
        case .maximize:
            Color.green
        }
    }
    
    @ViewBuilder private func buttonsRow(types: [ToolBarButtonType]) -> some View {
        HStack(spacing: 8) {
            ForEach(types) { type in
                button(for: type)
            }
        }
    }
    
}
