/**
 Model for aggregating search results.
 */
struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

/**
 A model to represent an app and related data.
 */
struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    let artworkUrl100: String
    let screenshotUrls: [String]
    var formattedPrice: String?
    let description: String
    let releaseNotes: String?
}

typealias App = Result
