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
    @Published var cast: [CastMember] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
        
        // Débouncer pour éviter les requêtes trop rapides lors de la saisie dans la barre de recherche
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
        
        // Identifiants des plateformes à récupérer
        let platforms = ["Disney+": 337, "Netflix": 8, "Prime Video": 119, "Apple TV+": 350, "OCS": 531, "Crunchyroll": 283]
        
        // Combine plusieurs appels API dans une seule opération
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
    
    // Filtre les séries en fonction du texte de recherche
    func filterSeries() {
        if searchText.isEmpty {
            filteredSeries = []
        } else {
            filteredSeries = (trendingSeries + topRatedSeries + seriesByPlatform.values.flatMap { $0 })
                .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // Récupère le casting pour une série spécifique
    func fetchCast(for seriesId: Int) {
        apiService.fetchCast(for: seriesId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] castResponse in
                self?.cast = castResponse.cast
            })
            .store(in: &cancellables)
    }
}
