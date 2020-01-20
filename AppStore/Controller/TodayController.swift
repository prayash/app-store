import UIKit

class TodayController: UICollectionViewController {

    private let cellId = "cellId"

    /// We keep track of the initial frame of a cell whenever it's tapped to facilitate animation
    var focusedCellInitialFrame: CGRect?

    /// The fullscreen controller for each cell in the Today feed
    var fullscreenController: UIViewController!

    // MARK: - Lifecycle

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
    }

    // MARK: - Collection View

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCell
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullscreenController = TodayFullscreenController()
        let expandedCellView = fullscreenController.view!
        view.addSubview(expandedCellView)
        addChild(fullscreenController)
        self.fullscreenController = fullscreenController

        expandedCellView.layer.cornerRadius = 16
        expandedCellView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        expandedCellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))


        if let cell = collectionView.cellForItem(at: indexPath),
            let initialCellFrame = cell.superview?.convert(cell.frame, to: nil) {
            // Let's write that tapped cell's initial frame to our instance property
            self.focusedCellInitialFrame = initialCellFrame
            expandedCellView.frame = initialCellFrame

            // Animate to the destination, which is the parent view's frame
            UIView.animate(
                withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
                options: .curveEaseOut, animations: {
                    expandedCellView.frame = self.view.frame
                    self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            }, completion: nil)
        }
    }

    @objc func handleRemoveRedView(gesture: UITapGestureRecognizer) {
        UIView.animate(
            withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7,
            options: .curveEaseOut, animations: {
                gesture.view?.frame = self.focusedCellInitialFrame ?? .zero
                if let tabBarFrame = self.tabBarController?.tabBar.frame {
                    self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
                }
        }) { _ in
            gesture.view?.removeFromSuperview()
            self.fullscreenController.removeFromParent()
        }
    }

}

// MARK: - Collection View Flow Layout

extension TodayController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: 450)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
