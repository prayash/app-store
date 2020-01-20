import UIKit

class ScreenshotCell: UICollectionViewCell {

    let imageView = CachedImageView(cornerRadius: 12, emptyImage: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        imageView.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
