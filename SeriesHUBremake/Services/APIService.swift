import Foundation
import Combine

class APIService {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOTg1MmM3Mjk1MTQ5YWZmOGUwMjljYjg2MWNmYTA0YiIsIm5iZiI6MTcyNjIxNjYyMy45Nzk4NjMsInN1YiI6IjY2ZTNmOGY5ZjQ2N2MyYWQ2MmY5NjFjNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KkJNnp0K98eGy74T0X1ktgzDDJMU8qnZ7JCVBDy8NjM"
    
    func fetchTrendingSeries() -> AnyPublisher<[Series], Error> {
        fetchSeriesWithMultiplePages(endpoint: "/trending/tv/week")
    }
    
    func fetchTopRatedSeries() -> AnyPublisher<[Series], Error> {
        fetchSeriesWithMultiplePages(endpoint: "/tv/top_rated")
    }
    
    func fetchSeriesForPlatform(platformId: Int) -> AnyPublisher<[Series], Error> {
        var components = URLComponents(string: "\(baseURL)/discover/tv")!
        components.queryItems = [
            URLQueryItem(name: "language", value: "fr-FR"),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "with_watch_providers", value: String(platformId)),
            URLQueryItem(name: "watch_region", value: "FR")
        ]
        return fetchSeriesWithMultiplePages(url: components.url!)
    }
    
    func fetchSeriesDetails(id: Int) -> AnyPublisher<Series, Error> {
        let endpoint = "/tv/\(id)"
        var components = URLComponents(string: "\(baseURL)\(endpoint)")!
        components.queryItems = [
            URLQueryItem(name: "language", value: "fr-FR"),
            URLQueryItem(name: "append_to_response", value: "credits")
        ]
        
        return fetchSeriesDetail(url: components.url!)
    }
    
    func fetchCast(for seriesId: Int) -> AnyPublisher<CastResponse, Error> {
        let endpoint = "/tv/\(seriesId)/credits"
        var components = URLComponents(string: "\(baseURL)\(endpoint)")!
        components.queryItems = [
            URLQueryItem(name: "language", value: "fr-FR")
        ]
        
        return fetchData(url: components.url!, type: CastResponse.self)
    }
    
    func fetchSeriesByActor(actorId: Int) -> AnyPublisher<[Series], Error> {
        print("Fetching series for actorId: \(actorId)")  // Debugging actorId

        guard var components = URLComponents(string: "\(baseURL)/discover/tv") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        components.queryItems = [
            URLQueryItem(name: "with_cast", value: String(actorId)),
            URLQueryItem(name: "language", value: "fr-FR"),
            URLQueryItem(name: "sort_by", value: "popularity.desc")
        ]

        print("Final URL: \(components.url?.absoluteString ?? "Invalid URL")")

        return fetchData(url: components.url!, type: TMDBResponse.self)
            .map { response -> [Series] in
                print("Fetched series: \(response.results)")
                return response.results
            }
            .eraseToAnyPublisher()
    }

    private func fetchSeriesWithMultiplePages(endpoint: String) -> AnyPublisher<[Series], Error> {
        var components = URLComponents(string: "\(baseURL)\(endpoint)")!
        components.queryItems = [
            URLQueryItem(name: "language", value: "fr-FR")
        ]
        return fetchSeriesWithMultiplePages(url: components.url!)
    }
    
    private func fetchSeriesWithMultiplePages(url: URL) -> AnyPublisher<[Series], Error> {
        let pagePublisher = CurrentValueSubject<Int, Never>(1)
        let maxPages = 5
        
        return pagePublisher
            .flatMap { page -> AnyPublisher<TMDBResponse, Error> in
                var pageUrl = url
                pageUrl.append(queryItems: [URLQueryItem(name: "page", value: String(page))])
                return self.fetchData(url: pageUrl, type: TMDBResponse.self)
            }
            .handleEvents(receiveOutput: { response in
                if pagePublisher.value < maxPages {
                    pagePublisher.send(pagePublisher.value + 1)
                } else {
                    pagePublisher.send(completion: .finished)
                }
            })
            .reduce([Series](), { accumulator, response in
                accumulator + response.results
            })
            .eraseToAnyPublisher()
    }
    
    private func fetchSeriesDetail(url: URL) -> AnyPublisher<Series, Error> {
        fetchData(url: url, type: Series.self)
    }
    
    private func fetchData<T: Decodable>(url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

// Extension to append query items to an existing URL
extension URL {
    mutating func append(queryItems: [URLQueryItem]) {
        guard var components = URLComponents(string: self.absoluteString) else { return }
        components.queryItems = (components.queryItems ?? []) + queryItems
        self = components.url!
    }
}
