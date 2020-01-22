import UIKit

class TodayCellItem: UICollectionViewCell {
    var todayItem: TodayItem?
}

class TodayCell: TodayCellItem {

    override var todayItem: TodayItem? {
        didSet {
            categoryLabel.text = todayItem?.category.uppercased()
            titleLabel.text = todayItem?.title
            descriptionLabel.text = todayItem?.description
            imageView.image = todayItem?.image
            backgroundColor = todayItem?.bgColor
        }
    }

    let categoryLabel = UILabel(text: "CATEGORY", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Cell Title", font: .systemFont(ofSize: 28, weight: .bold), numberOfLines: 2)
    let imageView = UIImageView(image: UIImage())
    let descriptionLabel = UILabel(text: "Some decently long description of what this cell is about", font: .systemFont(ofSize: 14), numberOfLines: 3)

    var topConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white

        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 240, height: 240))
        imageContainerView.clipsToBounds = true
        backgroundColor = .systemBlue
        clipsToBounds = true

        let vStack = VStack(subviews: [
            categoryLabel,
            titleLabel,
            imageContainerView,
            descriptionLabel
        ], spacing: 8)
        addSubview(vStack)

        vStack.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 24, left: 24, bottom: 24, right: 24))
        self.topConstraint = vStack.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstraint?.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
