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

    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"

        VStack(spacing: 8) {
            Image("TahoeIcon")
                .resizable()
                .frame(width: 67, height: 67)
                .cornerRadius(4)
                .padding(.top, 10)
                .padding(.bottom, 5)

            Text("SuperCorners ")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
                +
                Text(version)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            Form {
                Section {
                    HStack {
                        Text("Version")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(version)
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
            .frame(maxWidth: 725)
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
        .frame(width: 400, height: 480)
    }
}
