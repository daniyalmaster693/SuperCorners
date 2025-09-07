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
    @State private var selectedTags: Set<String> = []
    @State private var selectedActionID: String?
    @State private var showTemplateModal = false
    @State private var templateInput = ""

    let corner: CornerPosition.Corner
    var onUpdate: () -> Void

    let allTags: [String] = {
        let tags = cornerActions.map { $0.tag }
        return Array(Set(tags)).sorted()
    }()

    var filteredActions: [CornerAction] {
        let searchFiltered = searchText.isEmpty
            ? cornerActions
            : cornerActions.filter { action in
                action.title.lowercased().contains(searchText.lowercased()) ||
                    action.description.lowercased().contains(searchText.lowercased())
            }

        if selectedTags.isEmpty {
            return searchFiltered
        } else {
            return searchFiltered.filter { action in
                selectedTags.contains(action.tag)
            }
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("Action Library")
                .font(.title)
                .padding(.top, 15)
                .padding(.bottom, 12)
                .bold()

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search Actions", text: $searchText)
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
            .padding(.bottom, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(allTags, id: \.self) { tag in
                        Button(action: {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }) {
                            Text(tag)
                                .font(.subheadline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(
                                    Group {
                                        if selectedTags.contains(tag) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.accentColor.opacity(0.2))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                                                )
                                        } else {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color(NSColor.controlBackgroundColor))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                                                )
                                        }
                                    }
                                )
                                .foregroundColor(selectedTags.contains(tag) ? .accentColor : .primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .frame(maxWidth: 325)
            .padding(.bottom, 15)

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
                                    .frame(width: 15, height: 15)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(action.title)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)

                                    Text(action.description)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }

                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        selectedActionID == action.id
                                            ? (colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.05))
                                            : Color.clear
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.secondary.opacity(0.15), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .padding(.top, 5)
            .frame(maxWidth: 350, maxHeight: 225)
            .padding(.bottom, 15)

            Divider().frame(maxWidth: 350)

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button("Done") {
                    if let selectedID = selectedActionID,
                       let selectedAction = cornerActions.first(where: { $0.id == selectedID })
                    {
                        if selectedAction.requiresInput {
                            templateInput = ""
                            showTemplateModal = true
                        } else {
                            UserDefaults.standard.set(selectedAction.id, forKey: "cornerBinding_\(corner.rawValue)")
                            onUpdate()
                            dismiss()
                        }
                    } else {
                        showErrorToast("Please Select an Action First")
                    }
                }
                .keyboardShortcut(.defaultAction)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 3)
            .frame(maxWidth: 350)
        }
        .padding(.top, 15)
        .frame(minWidth: 250, minHeight: 440)
        .padding()
        .sheet(isPresented: $showTemplateModal) {
            VStack(spacing: 12) {
                Text(cornerActions.first(where: { $0.id == selectedActionID })?.inputPrompt ?? "Enter Input")
                    .font(.title2)
                    .padding(.top, 15)
                    .padding(.bottom, 2)
                    .bold()

                Text("Enter a valid input for the action to assign it")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
                    .frame(maxWidth: 350)

                TextField("Enter Action Input...", text: $templateInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 350, maxHeight: 230)
                    .padding(.bottom, 25)

                Divider().frame(maxWidth: 350)

                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Button("Assign") {
                        if let selectedID = selectedActionID,
                           let selectedAction = cornerActions.first(where: { $0.id == selectedID })
                        {
                            UserDefaults.standard.set(selectedAction.id, forKey: "cornerBinding_\(corner.rawValue)")
                            UserDefaults.standard.set(templateInput, forKey: "cornerInput_\(corner.rawValue)")
                            onUpdate()
                            showTemplateModal = false
                            dismiss()
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(templateInput.trimmingCharacters(in: .whitespaces).isEmpty)
                    .keyboardShortcut(.defaultAction)
                    .frame(maxWidth: 375, alignment: .trailing)
                }
            }
            .frame(width: 325)
            .padding(.top, 15)
            .padding()
            .onAppear {
                guard templateInput.isEmpty,
                      let inputPrompt = cornerActions.first(where: { $0.id == selectedActionID })?.inputPrompt
                else {
                    return
                }

                switch inputPrompt {
                case "Enter Application Path":
                    templateInput = "Applications/"
                case "Enter Website URL":
                    templateInput = "https://"
                case "Enter Folder Path", "Enter File Path", "Enter AppleScript File Path", "Enter Bash Script File Path":
                    let homePath = FileManager.default.homeDirectoryForCurrentUser.path
                    templateInput = "\(homePath)/"
                default:
                    break
                }
            }
        }
    }
}
