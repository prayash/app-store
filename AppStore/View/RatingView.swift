import UIKit

class RatingView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        (0..<5).forEach { _ in
            let imageView = UIImageView(image: UIImage(named: "review-star"))
            imageView.constrainWidth(constant: 24)
            imageView.constrainHeight(constant: 24)
            addArrangedSubview(imageView)
        }

        addArrangedSubview(UIView())
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(rating: Int) {
        for (index, view) in arrangedSubviews.enumerated() {
            view.alpha = index >= rating ? 0 : 1
        }
    }

}
