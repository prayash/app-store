import UIKit

/**
 Handles the entire Apps screen via child collection views. The child collection views are
 `UICollectionViewController` instances with horizontal scrolling. These two children are
 made up of `AppsGroupController` and `AppsHeaderController`.

 It fetches curation data via the iTunes RSS Feed and feeds them into the corresponding
 child collection views.
 */
class AppsPageController: UICollectionViewController {

    // MARK: - Properties

    private let cellId = "AppCell"
    private let headerId = "HeaderCell"
    private var groups = [AppGroup]()
    private var featuredApps = [FeaturedApp]()
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        view.color = UIColor(named: "activityIndicator")
        view.startAnimating()
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: - Lifecycle

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        fetchData()
    }

    private func fetchData() {
        var group1: AppGroup?
        var group2: AppGroup?
        var group3: AppGroup?
        var featured: [FeaturedApp]?

        let dataDispatchGroup = DispatchGroup()

        dataDispatchGroup.enter()
        Network.shared.fetch(of: .newGames) { appGroup, error in
            dataDispatchGroup.leave()
            if let group = appGroup {
                group1 = group
            }
        }

        dataDispatchGroup.enter()
        Network.shared.fetch(of: .topGrossing) { appGroup, error in
            dataDispatchGroup.leave()
            if let group = appGroup {
                group2 = group
            }
        }

        dataDispatchGroup.enter()
        Network.shared.fetch(of: .topFree) { appGroup, error in
            dataDispatchGroup.leave()
            if let group = appGroup {
                group3 = group
            }
        }

        dataDispatchGroup.enter()
        Network.shared.fetchFeaturedApps { apps, _ in
            dataDispatchGroup.leave()
            if let apps = apps {
                featured = apps
            }
        }

        dataDispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()

            self.featuredApps = featured ?? []
            [group1, group2, group3].forEach {
                if let g = $0 { self.groups.append(g) }
            }

            self.collectionView.reloadData()
        }
    }

    // MARK: - Collection View

    func configureView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        let appGroup = groups[indexPath.item]

        cell.titleLabel.text = appGroup.feed.title
        cell.appsGroupController.appGroup = appGroup
        cell.appsGroupController.onSelect = { [unowned self] feedResult in
            let appDetailController = AppDetailController(appId: feedResult.id)
            self.navigationController?.pushViewController(appDetailController, animated: true)
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appsHeaderController.featuredApps = self.featuredApps

        return header
    }
    
}

 // MARK: - Collection View Flow Layout

extension AppsPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 260)
    }
}
