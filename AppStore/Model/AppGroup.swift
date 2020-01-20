import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [Result]

    struct Result: Decodable {
        let id, name, artistName, artworkUrl100: String
    }
}
