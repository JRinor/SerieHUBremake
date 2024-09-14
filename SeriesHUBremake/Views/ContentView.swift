import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SeriesViewModel()
    @State private var showMenu = false
    @State private var isSearching = false
    
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
                            if isSearching {
                                SearchResultsView(series: viewModel.filteredSeries)
                            } else {
                                SectionView(title: "Tendances", series: viewModel.trendingSeries)
                                SectionView(title: "Les mieux notées", series: viewModel.topRatedSeries)
                                
                                ForEach(viewModel.seriesByPlatform.keys.sorted(), id: \.self) { platform in
                                    SectionView(title: platform, series: viewModel.seriesByPlatform[platform] ?? [])
                                }
                            }
                        }
                    }
                    .padding(.top, 100)
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
                                .font(.system(size: 22))
                        }
                        
                        Spacer()
                        
                        // Logo avec action pour retourner à l'accueil
                        Button(action: {
                            withAnimation {
                                self.isSearching = false
                                viewModel.searchText = ""
                                // Remplacez le contenu actuel par la vue d'accueil
                                // Cela simule une redirection vers la page d'accueil
                            }
                        }) {
                            if let logo = UIImage(named: "Logo") ?? UIImage(named: "Logo.png") {
                                Image(uiImage: logo)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                            } else {
                                Text("SeriesHUB")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.isSearching.toggle()
                                if !isSearching {
                                    viewModel.searchText = ""
                                }
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    
                    if isSearching {
                        SearchBar(text: $viewModel.searchText)
                    }
                    
                    Spacer()
                }
                .edgesIgnoringSafeArea(.top)
                
                SideMenuView(isOpen: $showMenu, width: 270, onClose: {
                    withAnimation {
                        self.showMenu = false
                    }
                }, onMenuItemSelected: { item in
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Rechercher une série", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
        .padding(.top, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
