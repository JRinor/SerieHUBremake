import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SeriesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        SectionView(title: "Tendances", series: viewModel.trendingSeries)
                        SectionView(title: "Les mieux notées", series: viewModel.topRatedSeries)
                        
                        ForEach(viewModel.seriesByPlatform.keys.sorted(), id: \.self) { platform in
                            SectionView(title: platform, series: viewModel.seriesByPlatform[platform] ?? [])
                        }
                    }
                }
            }
            .navigationTitle("Séries TV")
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}
