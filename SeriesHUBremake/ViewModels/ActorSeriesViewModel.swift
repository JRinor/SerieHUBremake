import Foundation
import Combine

class ActorSeriesViewModel: ObservableObject {
    @Published var series: [Series] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func fetchSeries(for actorId: Int) {
        isLoading = true
        apiService.fetchSeriesForActor(actorId: actorId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching series: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to fetch series: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] series in
                self?.series = series
            })
            .store(in: &cancellables)
    }
}
