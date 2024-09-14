import Foundation
import Combine

class SeriesViewModel: ObservableObject {
    @Published var trendingSeries: [Series] = []
    @Published var topRatedSeries: [Series] = []
    @Published var seriesByPlatform: [String: [Series]] = [
        "Disney+": [],
        "Netflix": [],
        "Prime Video": [],
        "Apple TV+": [],
        "OCS": [],
        "Crunchyroll": []
    ]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var filteredSeries: [Series] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterSeries()
            }
            .store(in: &cancellables)
    }
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        let platforms = ["Disney+": 337, "Netflix": 8, "Prime Video": 119, "Apple TV+": 350, "OCS": 531, "Crunchyroll": 283]
        
        Publishers.Zip3(
            apiService.fetchTrendingSeries(),
            apiService.fetchTopRatedSeries(),
            Publishers.MergeMany(platforms.map { platform, id in
                apiService.fetchSeriesForPlatform(platformId: id)
                    .map { (platform, $0) }
            })
            .collect()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] trending, topRated, platformResults in
            self?.trendingSeries = trending
            self?.topRatedSeries = topRated
            for (platform, series) in platformResults {
                self?.seriesByPlatform[platform] = series
            }
            self?.filterSeries()
        }
        .store(in: &cancellables)
    }
    
    func filterSeries() {
        if searchText.isEmpty {
            filteredSeries = []
        } else {
            filteredSeries = (trendingSeries + topRatedSeries + seriesByPlatform.values.flatMap { $0 })
                .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
