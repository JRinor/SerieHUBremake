import SwiftUI

struct SideMenuView: View {
    @Binding var isOpen: Bool
    let onClose: () -> Void
    let onMenuItemSelected: (String) -> Void
    @State private var showAuthenticationView = false
    
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
                        // Ajustement du padding pour positionner légèrement plus bas
                        ScrollView {
                            VStack(alignment: .leading, spacing: 25) {
                                MenuSection(title: "Parcourir", items: [
                                    MenuItem(title: "Accueil", icon: "house"),
                                    MenuItem(title: "Séries", icon: "tv")
                                ], onMenuItemSelected: onMenuItemSelected, showAuthenticationView: $showAuthenticationView)
                                .padding(.top, 30)  // Padding légèrement réduit pour un meilleur placement
                                
                                Divider()
                                    .background(Color.gray)
                                    .padding(.vertical)
                                
                                MenuSection(title: "Bibliothèque", items: [
                                    MenuItem(title: "Ma Liste", icon: "heart")
                                ], onMenuItemSelected: onMenuItemSelected, showAuthenticationView: $showAuthenticationView)
                                
                                Divider()
                                    .background(Color.gray)
                                    .padding(.vertical)
                                
                                MenuSection(title: "Paramètres", items: [
                                    MenuItem(title: "Compte", icon: "person.circle")
                                ], onMenuItemSelected: onMenuItemSelected, showAuthenticationView: $showAuthenticationView)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .background(Color.black.opacity(0.9))
                    .edgesIgnoringSafeArea(.vertical)
                    .offset(x: isOpen ? 0 : -UIScreen.main.bounds.width)
                    .animation(.default)
                    
                    Spacer()
                }
            }
            
            NavigationLink(destination: AuthenticationView(), isActive: $showAuthenticationView) {
                EmptyView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MenuSection: View {
    let title: String
    let items: [MenuItem]
    let onMenuItemSelected: (String) -> Void
    @Binding var showAuthenticationView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            ForEach(items) { item in
                Button(action: {
                    if item.title == "Compte" {
                        showAuthenticationView = true
                    } else {
                        onMenuItemSelected(item.title)
                    }
                }) {
                    HStack(spacing: 15) {
                        Image(systemName: item.icon)
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .frame(width: 24, height: 24)
                        
                        Text(item.title)
                            .foregroundColor(.white)
                            .font(.body)

                        Spacer()
                    }
                }
            }
        }
    }
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}
