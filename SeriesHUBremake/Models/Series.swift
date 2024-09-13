import Foundation

struct Series: Identifiable, Codable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    var imageUrl: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

struct TMDBResponse: Codable {
    let results: [Series]
}
