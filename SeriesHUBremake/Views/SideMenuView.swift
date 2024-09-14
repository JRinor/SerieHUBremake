import SwiftUI

struct SideMenuView: View {
    @Binding var isOpen: Bool
    let width: CGFloat
    let onClose: () -> Void
    let onMenuItemSelected: (String) -> Void
    
    var body: some View {
        ZStack {
            if isOpen {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            onClose()
                        }
                    }
                
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Menu")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 50)
                            .padding(.bottom, 30)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 25) {
                            MenuItemView(title: "Recherche", icon: "magnifyingglass") {
                                onMenuItemSelected("Recherche")
                            }
                            
                            MenuItemView(title: "Acteurs", icon: "person.2") {
                                onMenuItemSelected("Acteurs")
                            }
                            
                            MenuItemView(title: "Genre", icon: "film") {
                                onMenuItemSelected("Genre")
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .frame(width: width)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.9), Color.gray.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    )
                    .edgesIgnoringSafeArea(.vertical)
                    .offset(x: isOpen ? 0 : -width)
                    .animation(.default)
                    
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
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
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                
                Spacer()
            }
        }
    }
}
