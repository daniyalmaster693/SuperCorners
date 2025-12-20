//
//  AppLinksView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import SwiftUI

struct AppLinksView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("enableTopLeftCorner") private var enableTopLeftCorner = true
    @AppStorage("enableTopRightCorner") private var enableTopRightCorner = true
    @AppStorage("enableBottomLeftCorner") private var enableBottomLeftCorner = true
    @AppStorage("enableBottomRightCorner") private var enableBottomRightCorner = true

    @State private var isHovering = false

    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"

        VStack(spacing: 8) {
            Image("TahoeIcon")
                .resizable()
                .frame(width: 77, height: 77)
                .cornerRadius(4)
                .padding(.top, 15)
                .padding(.bottom, 10)
                .scaleEffect(isHovering ? 1.05 : 1.0)
                .onHover { hovering in
                    withAnimation(.interpolatingSpring(stiffness: 180, damping: 10)) {
                        isHovering = hovering
                    }
                }

            Text("SuperCorners ")
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(.primary)
                +
                Text(version)
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(.secondary)

            Form {
                Section {
                    HStack {
                        Text("Version")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(version) (\(build))")
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("Links")) {
                    ForEach(
                        [
                            ("Website", "https://supercorners.vercel.app"),
                            ("Repository", "https://github.com/daniyalmaster693/SuperCorners"),
                            ("Feedback", "https://github.com/daniyalmaster693/SuperCorners/issues/new"),
                            ("Changelog", "https://github.com/daniyalmaster693/SuperCorners/releases"),

                        ],
                        id: \.0
                    ) { item in
                        Button(action: {
                            if let url = URL(string: item.1) {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            HStack {
                                Text(item.0)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
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
        .frame(width: 400, height: 520)
    }
}
