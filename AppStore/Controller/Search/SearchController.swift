import UIKit
import SDWebImage

class SearchController: UICollectionViewController {

    private let id = "SearchCell"
    private let cellHeight: CGFloat = 300
    private var results: [Result] = []
    private let searchController = UISearchController(searchResultsController: nil)

    /// Container to hold search requests for easy deferring & cancelling.
    private var searchTask = DispatchWorkItem {
        // No search task defined until the searchBar is updated.
    }

    // MARK: - Lifecycle

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: id)

        setupSearchBar()
        fetch(text: "Pandora")
    }

    // MARK: - Helpers

    private func fetch(text: String) {
        Network.shared.fetchApps(withQuery: text) { res, _ in
            self.results = res?.results ?? []
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Games, Apps, Stories, and More"
    }

    // MARK: - Collection View

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! SearchResultCell
        cell.appResult = results[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = String(results[indexPath.item].trackId)
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

// MARK: - Collection View Flow Layout

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: cellHeight)
    }
}

// MARK: - Search Bar

extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask.cancel()
        searchTask = DispatchWorkItem { [unowned self] in
            self.fetch(text: searchText)
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: searchTask)
    }
}
