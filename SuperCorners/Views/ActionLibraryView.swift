//
//  ActionLibraryView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct ActionLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Action Library")
                .font(.title)
                .bold()
            
            Text("Action library modal content goes here.")
                .foregroundColor(.secondary)
            
            Button("Done") {
                dismiss()
            }
        }
        .frame(minWidth: 400, minHeight: 300)
        .padding()
    }
}

struct ActionLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ActionLibraryView()
    }
}
