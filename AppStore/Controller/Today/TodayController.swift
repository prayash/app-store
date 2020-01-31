import UIKit

class TodayController: UICollectionViewController {

    /// We keep track of the initial frame of a cell whenever it's tapped to facilitate animation
    var focusedCellInitialFrame: CGRect?

    /// The fullscreen controller for each cell in the Today feed
    var fullscreenController: TodayFullscreenController!

    /// Data source for all Today cards
    var items = [TodayItem]()

    /// A set of constraints for the expanding/contracting of cells.
    var cellTopConstraint: NSLayoutConstraint?
    var cellLeadingConstraint: NSLayoutConstraint?
    var cellWidthConstraint: NSLayoutConstraint?
    var cellHeightConstraint: NSLayoutConstraint?

    static let CELL_SIZE: CGFloat = 500

    let activityIndicatorView: UIActivityIndicatorView = {
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

        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()

        navigationController?.isNavigationBarHidden = true
        configureCollectionView()
        fetchData()
    }

    private func fetchData() {
        let dispatchGroup = DispatchGroup()

        var topGrossing: AppGroup?

        dispatchGroup.enter()
        Network.shared.fetch(of: .topGrossing) { appGroup, error in
            topGrossing = appGroup
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.items = [
                TodayItem.init(category: "Inspiring Stories", title: "Credit Where It's (Honey) Due", image: UIImage(named: "honeydue")!, description: "Travis and Brianna were $20,000 in debt. Then they downloaded Honeydue.", bgColor: UIColor(named: "cream2")!, cellType: .article, apps: []),
                TodayItem.init(category: "The Daily List", title: topGrossing?.feed.title ?? "", image: UIImage(named: "productivity")!, description: "", bgColor: UIColor(named: "getBtn")!, cellType: .apps, apps: topGrossing?.feed.results ?? []),
                TodayItem.init(category: "FEATURED APP", title: "Looking to meditate?", image: UIImage(named: "oak-graphic")!, description: "A meditation app that helps you get to the root of your stresses", bgColor: UIColor(named: "secondaryGray")!, cellType: .featuredApp, apps: [])
            ]

            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }

    // MARK: - Collection View

    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.article.rawValue)
        collectionView.register(TodayAppsCell.self, forCellWithReuseIdentifier: TodayItem.CellType.apps.rawValue)
        collectionView.register(TodayFeaturedAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.featuredApp.rawValue)
        collectionView.register(TodayHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)

        return headerView
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCellItem
        cell.todayItem = items[indexPath.item]

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // This cell will render a modal!
        if items[indexPath.item].cellType == .apps {
            let fullController = TodayAppsController(mode: .fullScreen)
            fullController.results = self.items[indexPath.item].apps
            fullController.view.backgroundColor = .systemBackground
            present(fullController, animated: true)
            return
        }


        // What we're doing here is instantiating a new view controller, taking
        // its root view, and manipulating its constraints, adding it to our current
        // view as a sibling of the entire `UICollectionView`.
        let fullscreenController = TodayFullscreenController()
        fullscreenController.item = items[indexPath.item]
        fullscreenController.dismissHandler = { [unowned self] in
            self.handleDismiss()
        }

        // Our expansion view is derived from the previously instantiated controller
        // And we take its root view and make it a part of the current view hierarchy.
        let expandedCellView = fullscreenController.view!
        view.addSubview(expandedCellView)
        addChild(fullscreenController)
        self.fullscreenController = fullscreenController

        // Disable the collectionView during animation
        self.collectionView.isUserInteractionEnabled = false

        // Apply corner radius to the cell to match the card cell
        expandedCellView.layer.cornerRadius = 16

        // First, we grab the selected cell, and grab its initial frame in its current state
        // The reason for this is so we can shrink it back to the exact same state!
        if let cell = collectionView.cellForItem(at: indexPath),
            let initialCellFrame = cell.superview?.convert(cell.frame, to: nil) {

            // We'll grab the cell's frame and persist it to our own copy of constraints
            expandedCellView.translatesAutoresizingMaskIntoConstraints = false
            cellTopConstraint = expandedCellView.topAnchor.constraint(equalTo: view.topAnchor, constant: initialCellFrame.origin.y)
            cellLeadingConstraint = expandedCellView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: initialCellFrame.origin.x)
            cellWidthConstraint = expandedCellView.widthAnchor.constraint(equalToConstant: initialCellFrame.width)
            cellHeightConstraint = expandedCellView.heightAnchor.constraint(equalToConstant: initialCellFrame.height)

            [cellTopConstraint, cellLeadingConstraint, cellWidthConstraint, cellHeightConstraint].forEach {
                $0?.isActive = true
            }

            self.view.layoutIfNeeded()

            // Let's write that tapped cell's initial frame to our instance property
            self.focusedCellInitialFrame = initialCellFrame
            expandedCellView.frame = initialCellFrame

            // Animate to the destination, which is the parent view's frame
            UIView.animate(
                withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                options: .curveEaseOut, animations: {
                    // Force the cell to take up the entire viewport
                    self.cellTopConstraint?.constant = 0
                    self.cellLeadingConstraint?.constant = 0
                    self.cellWidthConstraint?.constant = self.view.frame.width
                    self.cellHeightConstraint?.constant = self.view.frame.height
                    self.view.layoutIfNeeded()

                    // Hide the tab bar!
                    self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height

                    // Adjust the heading and description of the expanded cell
                    guard let cell = self.fullscreenController.tableView.cellForRow(at: [0, 0]) as? TodayFullscreenHeaderCell else { return }
                    cell.content.topConstraint?.constant = 48
                    cell.content.descriptionLabel.layer.opacity = 0.0
                    cell.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @objc func handleDismiss() {
        UIView.animate(
            withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
            options: .curveEaseOut, animations: {

                guard let initialCellFrame = self.focusedCellInitialFrame else { return }

                // Set all the constraints back to the original frame.
                self.cellTopConstraint?.constant = initialCellFrame.origin.y
                self.cellLeadingConstraint?.constant = initialCellFrame.origin.x
                self.cellWidthConstraint?.constant = initialCellFrame.width
                self.cellHeightConstraint?.constant = initialCellFrame.height
                self.view.layoutIfNeeded()

                self.fullscreenController.tableView.contentOffset = .zero

                // Show the tab bar!
                if let tabBarFrame = self.tabBarController?.tabBar.frame {
                    self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
                }

                guard let cell = self.fullscreenController.tableView.cellForRow(at: [0, 0]) as? TodayFullscreenHeaderCell else { return }
                cell.content.topConstraint?.constant = 24
                cell.content.descriptionLabel.alpha = 1.0
                cell.layoutIfNeeded()
        }) { _ in
            self.fullscreenController.view.removeFromSuperview()
            self.fullscreenController.removeFromParent()

            // Enable the collectionView once the dismissal animation is done
            self.collectionView.isUserInteractionEnabled = true
        }
    }

}

// MARK: - Collection View Flow Layout

extension TodayController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 40, height: TodayController.CELL_SIZE)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 18, left: 0, bottom: 32, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 72)
    }
}
