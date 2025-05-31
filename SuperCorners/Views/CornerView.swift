import SwiftUI

struct CornerView: View {
    @State private var showModal = false
    @State private var refreshID = UUID()
    
    
    var body: some View {
        let topLeftTitle = cornerActionBindings[.topLeft]?.title
        let topRightTitle = cornerActionBindings[.topRight]?.title
        let bottomLeftTitle = cornerActionBindings[.bottomLeft]?.title
        let bottomRightTitle = cornerActionBindings[.bottomRight]?.title
        
        func mapSelectedToCorner(_ selected: SelectedCornerPosition) -> CornerPosition.Corner {
            switch selected {
            case .topLeft: return .topLeft
            case .topRight: return .topRight
            case .bottomLeft: return .bottomLeft
            case .bottomRight: return .bottomRight
            }
        }
        
        return VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Configure Your Super Corners")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: 450, alignment: .leading)
                
                Text("Assign custom actions to your Mac’s screen corners. Click the button found at every corner to assign an action.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: 450, alignment: .leading)
            }
            .padding(.top, 25)
            .frame(maxWidth: 450)
            
            Spacer()
            
            ZStack {
                Image("SequoiaWallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 450, height: 275)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(alignment: .topLeading) {
                        Button(topLeftTitle ?? "Add Action") {
                            currentlySelectedCorner = .topLeft
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .topTrailing) {
                        Button(topRightTitle ?? "Add Action") {
                            currentlySelectedCorner = .topRight
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .bottomLeading) {
                        Button(bottomLeftTitle ?? "Add Action") {
                            currentlySelectedCorner = .bottomLeft
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button(bottomRightTitle ?? "Add Action") {
                            currentlySelectedCorner = .bottomRight
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 275)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .sheet(isPresented: $showModal) {
                if let selected = currentlySelectedCorner {
                    ActionLibraryView(corner: mapSelectedToCorner(selected)) {
                        refreshID = UUID()
                    }
                }
            }
        }
        .id(refreshID)
        .navigationTitle("Corners")
    }
}
