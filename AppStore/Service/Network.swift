import Foundation

enum FeedType: String {
    case topFree = "top-free"
    case topGrossing = "top-grossing"
    case newGames = "new-games-we-love"
}

class Network {

    static let shared = Network()

    private init() {}

    /**
     A generic data fetching routine.
     */
    func fetchData<T: Decodable>(from url: URL, onDone completion: @escaping (T?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, res, reqErr in
            if let reqErr = reqErr {
                print("Uh-oh!", reqErr)
                completion(nil, reqErr)
                return
            }

            guard let data = data else { return }
            do {
                let appGroup =  try JSONDecoder().decode(T.self, from: data)
                completion(appGroup, nil)
            } catch let decodingError {
                print("Failed to decode:", decodingError)
                completion(nil, nil)
            }
        }.resume()
    }

    func fetchApps(withQuery str: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        let endpoint = "https://itunes.apple.com/search?term=\(str)&entity=software"
        guard let url = URL(string: endpoint) else { return }

        fetchData(from: url, onDone: completion)
    }

    func createUrlForFeedType(_ type: FeedType) -> URL? {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/\(type.rawValue)/all/50/explicit.json"
        return URL(string: urlString)
    }

    func fetch(of type: FeedType, completion: @escaping (AppGroup?, Error?) -> ()) {
        guard let url = createUrlForFeedType(type) else { return }
        fetchData(from: url, onDone: completion)
    }

    func fetchFeaturedApps(completion: @escaping ([FeaturedApp]?, Error?) -> ()) {
        let mockEndpoint = "https://raw.githubusercontent.com/prayash/app-store/master/data/feed.json"
        guard let url = URL(string: mockEndpoint) else { return }
        fetchData(from: url, onDone: completion)
    }

    func fetchAppDetails(for id: String, completion: @escaping (SearchResult?, Error?) -> ()) {
        let endpoint = "https://itunes.apple.com/lookup?id=\(id)"
        guard let url = URL(string: endpoint) else { return }

        fetchData(from: url, onDone: completion)
    }

    func fetchAppReviews(for appId: String, completion: @escaping (Reviews?, Error?) -> ()) {
        let endpoint = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=en&cc=us"
        guard let url = URL(string: endpoint) else { return }

        fetchData(from: url, onDone: completion)
    }

}
