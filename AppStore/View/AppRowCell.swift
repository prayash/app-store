import UIKit

class AppRowCell: UICollectionViewCell {

    let nameLabel = UILabel(text: "App Name")
    let companyLabel = UILabel(text: "Company Label", font: .systemFont(ofSize: 13))
    let imageView = UIImageView(cornerRadius: 8) // Needs a border!
    let getBtn: UIButton = .createGetBtn()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        let imageViewWrapper = UIView(frame: imageView.frame)
        imageViewWrapper.constrainWidth(constant: 64)
        imageViewWrapper.constrainHeight(constant: 64)
        imageViewWrapper.addSubview(imageView)
        imageViewWrapper.layer.cornerRadius = 8.0
        imageViewWrapper.layer.borderWidth = 1.0
        imageViewWrapper.layer.borderColor = UIColor(white: 0.7, alpha: 0.5).cgColor
        imageView.fillSuperview()

        let stackView = UIStackView(arrangedSubviews: [
            imageViewWrapper,
            VStack(subviews: [nameLabel, companyLabel], spacing: 4),
            getBtn
        ])
        addSubview(stackView)
        stackView.fillSuperview()
        stackView.spacing = 16
        stackView.alignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
