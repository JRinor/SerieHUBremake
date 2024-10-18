import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SeriesViewModel()
    @State private var showMenu = false
    @State private var isSearching = false
    @State private var isInitialLoading = true

    var body: some View {
        ZStack {
            if isInitialLoading {
                LoadingView()
            } else {
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
                                Spacer()  // Retire le bouton de menu, garde l'espacement ici

                                // Logo or Title
                                if !isSearching {
                                    Button(action: {
                                        // Action when logo is tapped, if any
                                    }) {
                                        if let logo = UIImage(named: "Logo") ?? UIImage(named: "IMG/Track-R.png") {
                                            Image(uiImage: logo)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 50)
                                        } else {
                                            Text("SeriesHUB")
                                                .foregroundColor(.white)
                                                .font(.title)
                                                .fontWeight(.bold)
                                        }
                                    }
                                }

                                Spacer()

                                // Search Button
                                Button(action: {
                                    withAnimation {
                                        self.isSearching.toggle()
                                        if !isSearching {
                                            viewModel.searchText = ""
                                        }
                                    }
                                }) {
                                    Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                                        .foregroundColor(.white)
                                        .font(.system(size: 22))
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)

                            if isSearching {
                                SearchBar(text: $viewModel.searchText)
                                    .transition(.move(edge: .top))
                            }

                            Spacer()
                        }
                        .edgesIgnoringSafeArea(.top)
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .onAppear {
            viewModel.loadData()
            // Simulate an initial loading delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isInitialLoading = false
                }
            }
        }
    }
}
