import UIKit

class HSnappingController: UICollectionViewController {

    init() {
        let layout = SnappingLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Collection View Flow Layout

class SnappingLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        let nextX: CGFloat
        if proposedContentOffset.x <= 0 || collectionView.contentOffset == proposedContentOffset {
            nextX = proposedContentOffset.x
        } else {
            nextX = collectionView.contentOffset.x + (velocity.x > 0 ? collectionView.bounds.size.width : -collectionView.bounds.size.width)
        }

        let targetRect = CGRect(x: nextX, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude

         super.layoutAttributesForElements(in: targetRect)?.forEach { layoutAttributes in
            let itemOffset = layoutAttributes.frame.origin.x

            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    /**
     Calculates the next page and snaps to its position.
     https://stackoverflow.com/a/43637969/2272112
     */
    func calculatePageOffset(proposedOffset: CGPoint, viewSize: CGSize, velocity: CGPoint) -> CGPoint {
        return .zero
    }
}
