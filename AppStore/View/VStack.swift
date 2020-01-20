import UIKit

class VStack: UIStackView {
    init(subviews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)

        subviews.forEach { addArrangedSubview($0) }
        self.spacing = spacing
        self.axis = .vertical
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
