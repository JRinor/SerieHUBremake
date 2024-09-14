import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SeriesViewModel()
    @State private var showMenu = false
    @State private var selectedMenuItem: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        } else {
                            SectionView(title: "Tendances", series: viewModel.trendingSeries)
                            SectionView(title: "Les mieux notées", series: viewModel.topRatedSeries)
                            
                            ForEach(viewModel.seriesByPlatform.keys.sorted(), id: \.self) { platform in
                                SectionView(title: platform, series: viewModel.seriesByPlatform[platform] ?? [])
                            }
                        }
                    }
                    .padding(.top, 100) // Ajuster le padding pour éviter l'encoche
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("SeriesHUB")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            // Action pour la recherche
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top) // Ajuster pour l'encoche
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.top)
                
                SideMenuView(isOpen: $showMenu, width: 270, onClose: {
                    withAnimation {
                        self.showMenu = false
                    }
                }, onMenuItemSelected: { item in
                    self.selectedMenuItem = item
                    withAnimation {
                        self.showMenu = false
                    }
                    print("Selected menu item: \(item)")
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.loadData()
        }
    }
}
