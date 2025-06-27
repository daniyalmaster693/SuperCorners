//
//  TemplateAction.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-27.
//

import SwiftUI

struct TemplateModalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var inputText: String = ""

    var body: some View {
        VStack(spacing: 8) {
            Text("Enter Action Input")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 15)
                .padding(.bottom, 7)

            TextField("Enter Action Input...", text: $inputText)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 300)
                .padding(.bottom, 14)

            Divider().frame(maxWidth: 300)

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .frame(maxWidth: 300, alignment: .trailing)
            .padding(.top, 10)
        }
        .padding()
        .frame(width: 325)
        .formStyle(.grouped)
    }
}
