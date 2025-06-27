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
    let inputPrompt: String

    var body: some View {
        VStack(spacing: 8) {
            Text(inputPrompt)
                .font(.title)
                .padding(.top, 15)
                .bold()

            Text("Enter a valid input for the action to assign it")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 27)
                .frame(maxWidth: 300)

            TextField("Enter Action Input...", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 375, maxHeight: 230)
                .padding(.bottom, 25)

            Divider().frame(maxWidth: 375)

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .frame(maxWidth: 375, alignment: .trailing)
        }
        .padding(.top, 15)
        .frame(minWidth: 250, minHeight: 460)
        .padding()
    }
}
