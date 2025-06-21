//
//  AppLinksView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import SwiftUI

struct AppLinksView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                if let iconPath = Bundle.main.path(forResource: "AppIcon", ofType: "icns"),
                   let nsImage = NSImage(contentsOfFile: iconPath)
                {
                    Image(nsImage: nsImage)
                        .resizable()
                        .frame(width: 76, height: 76)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "app.fill")
                        .resizable()
                        .frame(width: 76, height: 76)
                        .cornerRadius(12)
                }

                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Text("SuperCorners ")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                        +
                        Text(version)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 0) {
                Text("Links")
                    .font(.headline)
                    .padding(.horizontal, 4)

                VStack(spacing: 0) {
                    self.linkRow("GitHub Repository", url: URL(string: "https://github.com")!)
                    self.linkRow("Privacy Policy", url: URL(string: "https://example.com/privacy")!)
                    self.linkRow("Terms and Conditions", url: URL(string: "https://example.com/terms")!)
                    self.linkRow("License", url: URL(string: "https://example.com/license")!)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal)

            Spacer()

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.cancelAction)
        }
        .padding()
        .frame(width: 375, height: 500)
    }
}

private extension AppLinksView {
    func linkRow(_ title: String, url: URL) -> some View {
        VStack(spacing: 0) {
            Button(action: {
                NSWorkspace.shared.open(url)
            }) {
                HStack {
                    Text(title)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle()) // makes whole row clickable
                .padding()
            }
            .buttonStyle(PlainButtonStyle())

            Divider()
                .padding(.leading)
        }
    }
}
