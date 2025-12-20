//
//  ActionSetEditor.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-20.
//

import AppKit
import SwiftUI

struct ActionSetEditor: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 6) {
            Text("Action Set Editor")
                .font(.title)
                .padding(.top, 25)
                .padding(.bottom, 12)
                .bold()

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search Action Sets", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
            .frame(maxWidth: 300)

            Form {}
                .formStyle(.grouped)
                .padding(.horizontal, -12)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 7)

            Divider()

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .padding(.top, 7)
        .frame(width: 385, height: 500)
    }
}
