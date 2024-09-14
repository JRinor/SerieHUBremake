import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SeriesViewModel()
    @State private var showMenu = false
    @State private var selectedMenuItem: String?
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            ContinuousScrollingSection(title: "Tendances", series: viewModel.trendingSeries, scrollDuration: 30)
                            ContinuousScrollingSection(title: "Les mieux notées", series: viewModel.topRatedSeries, scrollDuration: 35)
                            
                            ForEach(viewModel.seriesByPlatform.keys.sorted(), id: \.self) { platform in
                                ContinuousScrollingSection(
                                    title: platform,
                                    series: viewModel.seriesByPlatform[platform] ?? [],
                                    scrollDuration: Double.random(in: 25...40) // Durée aléatoire pour chaque plateforme
                                )
                            }
                        }
                    }
                }
                .navigationTitle("Séries TV")
                .navigationBarItems(leading: Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                })
            }
            
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
        .onAppear {
            viewModel.loadData()
        }
    }
}
