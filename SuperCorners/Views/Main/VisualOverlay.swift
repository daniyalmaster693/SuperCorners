//
//  VisualOverlay.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-07.
//

import AppKit
import SwiftUI

struct VisualOverlay: View {
    var body: some View {
        Rectangle()
            .fill(Color.accentColor.opacity(0.3))
            .overlay(
                Rectangle()
                    .stroke(Color.accentColor, lineWidth: 2)
            )
    }
}
