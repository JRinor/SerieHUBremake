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
                    .padding(.top, 100) // Augmentez cette valeur pour éviter le chevauchement
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
                        
                        if let image = UIImage(named: "Logo") {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 50)
                        } else {
                            Text("Logo non trouvé")
                                .foregroundColor(.red)
                        }
                        
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
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    
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
