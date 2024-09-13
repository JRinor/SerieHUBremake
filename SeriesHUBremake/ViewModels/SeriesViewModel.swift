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
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
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
        }
        .store(in: &cancellables)
    }
}
