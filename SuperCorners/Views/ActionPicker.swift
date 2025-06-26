//
//  ActionPicker.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct ActionLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme

    @State private var searchText = ""
    @State private var selectedActionID: String?

    let corner: CornerPosition.Corner
    var onUpdate: () -> Void

    var filteredActions: [CornerAction] {
        if searchText.isEmpty {
            return cornerActions
        } else {
            let lowercasedSearch = searchText.lowercased()
            return cornerActions.filter { action in
                let titleContains = action.title.lowercased().contains(lowercasedSearch)
                let descriptionContains = action.description.lowercased().contains(lowercasedSearch)
                return titleContains || descriptionContains
            }
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("Action Library")
                .font(.title)
                .padding(.top, 15)
                .bold()

            Text("Click an action to assign to select it, then click the done button to assign it.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 27)
                .frame(maxWidth: 300)

            TextField("Search Actions", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 375, alignment: .center)
                .padding(.bottom, 10)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(filteredActions) { action in
                        Button(action: {
                            selectedActionID = action.id
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: action.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.accentColor)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(action.title)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)

                                    Text(action.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        selectedActionID == action.id
                                            ? (colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.06))
                                            : Color.clear
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .frame(maxWidth: 375, maxHeight: 230)
            .padding(.bottom, 25)

            Divider().frame(maxWidth: 375)

            Button("Done") {
                if let selectedID = selectedActionID,
                   let selectedAction = cornerActions.first(where: { $0.id == selectedID })
                {
                UserDefaults.standard.set(selectedAction.id, forKey: "cornerBinding_\(corner.rawValue)")
                    onUpdate()
                }
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
