import UIKit

class AppDetailController: UICollectionViewController {

    private let detailCellId = "detailCell"
    private let previewCellId = "previewCell"
    private let reviewCellId = "reviewCell"

    var app: App?
    var reviews: Reviews?
    private let appId: String

    // MARK: - Lifecycle

    init(appId: String) {
        self.appId = appId
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)

        fetchDetails()
    }

    private func fetchDetails() {
        Network.shared.fetchAppDetails(for: appId) { result, error in
            self.app = result?.results.first

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        Network.shared.fetchAppReviews(for: appId) { reviews, error in
            self.reviews = reviews

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: - Collection View

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    /**
     Inside NSIndexPath, the indexes are stored in a simple c array called `_indexes` defined
     as `NSUInteger*` and the length of the array is stored in `_length` defined as `NSUInteger`.
     The accessor `section` is an alias to `_indexes[0]` and both `item` and `row` are aliases to
     `_indexes[1]`. Thus the two are functionally identical.

     In terms of programming style – and perhaps the definition chain – you would be better
     using `row` in the context of tables, and `item` in the context of collections.
     */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell

            cell.app = app
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
            cell.screenshotsController.app = self.app

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewRowCell
            cell.reviewsController.reviews = self.reviews

            return cell
        }
    }
}

// MARK: - Collection View Flow

extension AppDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: CGFloat = 280

        // We only want the auto-resizing view for the first cell which contains the release notes.
        if indexPath.item == 0 {
            // Calculate the necessarry size to fit the release notes.
            let dummy = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummy.app = app
            dummy.layoutIfNeeded()
            let estimatedSize = dummy.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))

            height = estimatedSize.height
        } else if indexPath.item == 1  {
            height = 500
        } else {
            height = 280
        }

        return .init(width: view.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}
