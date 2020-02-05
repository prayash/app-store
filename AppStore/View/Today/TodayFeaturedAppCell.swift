import UIKit

class TodayFeaturedAppCell: TodayCellItem {

    override var todayItem: TodayItem? {
        didSet {
            categoryLabel.text = todayItem?.category.uppercased()
            titleLabel.text = todayItem?.title
            descriptionLabel.text = todayItem?.description
            imageView.image = todayItem?.image
            backgroundColor = todayItem?.bgColor
        }
    }

    let categoryLabel = UILabel(text: "CATEGORY", font: .boldSystemFont(ofSize: 16))
    let titleLabel = UILabel(text: "Cell Title", font: .boldSystemFont(ofSize: 28), numberOfLines: 2)
    let imageView = UIImageView(image: UIImage(named: "productivity"))
    let descriptionLabel = UILabel(text: "Some decently long description of what this cell is about", font: .systemFont(ofSize: 14), numberOfLines: 3)

    var topConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        categoryLabel.textColor = UIColor(named: "primaryGray")
        descriptionLabel.textColor = UIColor(named: "primaryGray")

        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: imageContainerView.frame.width, height: 350))
        clipsToBounds = true

        let infoStack = VStack(subviews: [categoryLabel, titleLabel, descriptionLabel], spacing: 8)
        infoStack.directionalLayoutMargins = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
        infoStack.isLayoutMarginsRelativeArrangement = true

        let vStack = VStack(subviews: [
            imageView,
            infoStack
        ], spacing: 16)
        addSubview(vStack)

        vStack.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 24, right: 0))
        self.topConstraint = vStack.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        self.topConstraint?.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class TodayFeaturedAppFullscreenHeaderCell: UITableViewCell {

    let todayCell = TodayFeaturedAppCell()
    var onClose: (() -> ())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(todayCell)
        todayCell.fillSuperview()
    }

    @objc func close() {
        onClose?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
