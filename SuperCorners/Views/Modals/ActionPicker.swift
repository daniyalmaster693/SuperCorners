//
//  ActionPicker.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct ActionPicker: View {
    @ObservedObject private var actionSetManager = ActionSetManager.shared
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State private var selectedCategories: Set<ActionCategory> = []
    @State private var showFavoritesOnly = false
    
    @State private var selectedActionID: String?
    
    @State private var templateInput = ""
    @State private var showTemplateModal = false

    let corner: CornerPosition.Corner
    let actionSetID: String
    var onUpdate: () -> Void
    
    var allCategories: [ActionCategory] {
        Array(Set(cornerActions.map { $0.category }))
            .sorted { $0.rawValue < $1.rawValue }
    }
    
    var filteredActions: [CornerAction] {
        let searchFiltered = searchText.isEmpty
            ? cornerActions
            : cornerActions.filter { action in
                action.title.localizedCaseInsensitiveContains(searchText) ||
                    action.description.localizedCaseInsensitiveContains(searchText)
            }
        
        let categoryFiltered = selectedCategories.isEmpty
            ? searchFiltered
            : searchFiltered.filter { action in
                selectedCategories.contains(action.category)
            }

        if showFavoritesOnly {
            return categoryFiltered.filter { action in
                favoriteActionIDs[action.id] != nil
            }
        }

        return categoryFiltered
    }
    
    var selectedAction: CornerAction? {
        guard let selectedActionID else { return nil }
        return cornerActions.first { $0.id == selectedActionID }
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
                    ForEach(allCategories, id: \.self) { category in
                        Button(action: {
                            showFavoritesOnly = false
                            
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }) {
                            Text(category.rawValue.capitalized)
                                .font(.subheadline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 10)
                                .background(
                                    Group {
                                        if selectedCategories.contains(category) {
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
                                .foregroundColor(selectedCategories.contains(category) ? .accentColor : .primary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Button(action: {
                        showFavoritesOnly.toggle()
                        
                        if showFavoritesOnly {
                            selectedCategories.removeAll()
                        }
                    }) {
                        Text("Favorites")
                            .font(.subheadline)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background(
                                Group {
                                    if showFavoritesOnly {
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
                            .foregroundColor(showFavoritesOnly ? .accentColor : .primary)
                    }
                    .buttonStyle(PlainButtonStyle())
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
                        if selectedAction.inputType != .none {
                            templateInput = ""
                            showTemplateModal = true
                        } else {
                            actionSetManager.assignAction(actionID: selectedAction.id, input: nil, position: corner, setID: actionSetID)
                            
                            actionSetManager.saveConfig()
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
        .frame(minWidth: 250, minHeight: 450)
        .padding()
        .sheet(isPresented: $showTemplateModal) {
            if let selectedAction {
                TemplateModal(
                    action: selectedAction,
                    corner: corner,
                    actionSetID: actionSetID,
                    onUpdate: {
                        showTemplateModal = false
                        selectedActionID = nil
                        
                        onUpdate()
                        dismiss()
                    }
                )
            }
        }
    }
}
