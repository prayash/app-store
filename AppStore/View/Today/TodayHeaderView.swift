import UIKit

class TodayHeader: UICollectionReusableView {

    let dateLabel = UILabel(text: "TUESDAY, JANUARY 21", font: .boldSystemFont(ofSize: 16))
    let headingLabel = UILabel(text: "Today", font: .systemFont(ofSize: 32, weight: .bold), numberOfLines: 1)
    let avatarButton: UIButton = {
        let btn = UIButton()
        let avatar = UIImage(named: "avatar")!
        btn.setImage(avatar, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.constrainWidth(constant: 32)
        btn.constrainHeight(constant: 32)
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let headline = UIStackView(subviews: [headingLabel, UIView(), avatarButton])
        let infoStack = VStack(subviews: [dateLabel, headline], spacing: 8)
        addSubview(infoStack)

        dateLabel.textColor = UIColor(named: "primaryGray")!

        infoStack.fillSuperview(padding: .init(top: 12, left: 32, bottom: 0, right: 32))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
