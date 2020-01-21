import UIKit

class AppsGroupCell: UICollectionViewCell {

    let titleLabel = UILabel(text: "App Section", font: .systemFont(ofSize: 23, weight: .bold))
    let appsGroupController = AppsGroupController()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))

        addSubview(appsGroupController.view)
        appsGroupController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
