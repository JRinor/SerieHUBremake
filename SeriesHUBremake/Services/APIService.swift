import Foundation
import Combine

class APIService {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOTg1MmM3Mjk1MTQ5YWZmOGUwMjljYjg2MWNmYTA0YiIsIm5iZiI6MTcyNjIxNjYyMy45Nzk4NjMsInN1YiI6IjY2ZTNmOGY5ZjQ2N2MyYWQ2MmY5NjFjNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KkJNnp0K98eGy74T0X1ktgzDDJMU8qnZ7JCVBDy8NjM"
    
    func fetchTrendingSeries() -> AnyPublisher<[Series], Error> {
        fetchSeries(endpoint: "/trending/tv/week")
    }
    
    func fetchTopRatedSeries() -> AnyPublisher<[Series], Error> {
        fetchSeries(endpoint: "/tv/top_rated")
    }
    
    func fetchSeriesForPlatform(platformId: Int) -> AnyPublisher<[Series], Error> {
        var components = URLComponents(string: "\(baseURL)/discover/tv")!
        components.queryItems = [
            URLQueryItem(name: "language", value: "fr-FR"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "with_watch_providers", value: String(platformId)),
            URLQueryItem(name: "watch_region", value: "FR"),
            URLQueryItem(name: "page", value: "1")
        ]
        return fetchSeries(url: components.url!)
    }
    
    private func fetchSeries(endpoint: String) -> AnyPublisher<[Series], Error> {
        var components = URLComponents(string: "\(baseURL)\(endpoint)")!
        components.queryItems = [
            URLQueryItem(name: "language", value: "fr-FR"),
            URLQueryItem(name: "page", value: "1")
        ]
        return fetchSeries(url: components.url!)
    }
    
    private func fetchSeries(url: URL) -> AnyPublisher<[Series], Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TMDBResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .eraseToAnyPublisher()
    }
}
