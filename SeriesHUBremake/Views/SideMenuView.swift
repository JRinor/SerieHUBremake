import SwiftUI

struct SideMenuView: View {
    @Binding var isOpen: Bool
    let width: CGFloat
    let onClose: () -> Void
    let onMenuItemSelected: (String) -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.3))
            .opacity(isOpen ? 1.0 : 0.0)
            .animation(.easeIn(duration: 0.25))
            .onTapGesture {
                onClose()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Menu")
                        .font(.title)
                        .padding(.top, 60)
                        .padding(.bottom, 30)
                    
                    MenuItemView(title: "Recherche", icon: "magnifyingglass") {
                        onMenuItemSelected("Recherche")
                    }
                    
                    MenuItemView(title: "Acteurs", icon: "person.2") {
                        onMenuItemSelected("Acteurs")
                    }
                    
                    MenuItemView(title: "Genre", icon: "film") {
                        onMenuItemSelected("Genre")
                    }
                    
                    Spacer()
                }
                .frame(width: width)
                .background(Color(UIColor.systemBackground))
                .offset(x: isOpen ? 0 : -width)
                .animation(.default)
                
                Spacer()
            }
        }
    }
}

struct MenuItemView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .imageScale(.large)
                    .frame(width: 32, height: 32)
                
                Text(title)
                    .foregroundColor(.primary)
                    .font(.headline)
            }
        }
        .padding(.horizontal)
    }
}
