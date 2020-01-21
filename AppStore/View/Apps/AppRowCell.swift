import UIKit

class AppRowCell: UICollectionViewCell {

    var app: Feed.Result! {
        didSet {
            companyLabel.text = app?.artistName
            nameLabel.text = app?.name
            imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
        }
    }

    let nameLabel = UILabel(text: "App Name")
    let companyLabel = UILabel(text: "Company Label", font: .systemFont(ofSize: 13))
    let imageView = UIImageView(cornerRadius: 8) // Needs a border!
    let getBtn: UIButton = .createGetBtn()
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()

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

        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))

        stackView.spacing = 16
        stackView.alignment = .center

        backgroundColor = .clear
        stackView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
