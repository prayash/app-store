import UIKit

class ReviewCell: UICollectionViewCell {

    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 16))
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    let bodyLabel = UILabel(text: "Review body \nReview body", font: .systemFont(ofSize: 14), numberOfLines: 6)
    let ratingsView = RatingView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(named: "getBtn")
        layer.cornerRadius = 16
        clipsToBounds = true

        let stackView = VStack(subviews: [
            UIStackView(subviews: [titleLabel, authorLabel], customSpacing: 8),
            ratingsView,
            bodyLabel
        ], spacing: 12)

        titleLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        authorLabel.textAlignment = .right

        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
