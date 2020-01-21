import UIKit

class AppsHeaderCell: UICollectionViewCell {

    private let headingLabel = UILabel(text: "EDITOR'S CHOICE", font: .boldSystemFont(ofSize: 10))
    let titleLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 19))
    let taglineLabel = UILabel(text: "Some sorta catchy tagline", font: .systemFont(ofSize: 19))
    let imageView = UIImageView(cornerRadius: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)

        headingLabel.textColor = .systemBlue
        titleLabel.numberOfLines = 1
        imageView.contentMode = .scaleAspectFill
        taglineLabel.textColor = .gray
        let stackView = VStack(subviews: [headingLabel, titleLabel, taglineLabel, imageView], spacing: 2)

        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 12, left: 4, bottom: 12, right: 4))
        stackView.setCustomSpacing(12, after: taglineLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
