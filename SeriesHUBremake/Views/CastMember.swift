import Foundation

struct CastResponse: Decodable {
    let id: Int
    let cast: [CastMember]
}

struct CastMember: Identifiable, Decodable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
    
    var profileUrl: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)")
    }
}
