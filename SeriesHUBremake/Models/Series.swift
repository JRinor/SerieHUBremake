import Foundation

struct Series: Identifiable, Codable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let firstAirDate: String?
    let genres: [Genre]?
    let numberOfSeasons: Int?
    let status: String?
    let networks: [String]?
    let productionCompanies: [String]?
    let originCountry: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
        case genres
        case numberOfSeasons = "number_of_seasons"
        case status
        case networks
        case productionCompanies = "production_companies"
        case originCountry = "origin_country"
    }
    
    var imageUrl: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var backdropUrl: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w1280\(backdropPath)")
    }
    
    var genreNames: [String] {
        return genres?.map { $0.name } ?? []
    }
    
    var formattedFirstAirDate: String {
        guard let firstAirDate = firstAirDate else { return "Non disponible" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: firstAirDate) else { return "Non disponible" }
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: date)
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct TMDBResponse: Codable {
    let results: [Series]
}
