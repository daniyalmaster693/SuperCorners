//
//  ActionSetCreator.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-20.
//

import AppKit
import SwiftUI

struct ActionSetCreator: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 6) {
            Text("Action Set Creator")
                .font(.title)
                .padding(.top, 25)
                .padding(.bottom, 12)
                .bold()

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
