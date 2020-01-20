import UIKit

class SearchResultCell: UICollectionViewCell {

    var appResult: Result! {
        didSet {
            nameLabel.text = appResult.trackName
            categoryLabel.text = appResult.primaryGenreName
            ratingsView.update(rating: Int(appResult.averageUserRating ?? 0))
            iconView.sd_setImage(with: URL(string: appResult.artworkUrl100))
            s1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))

            if appResult.screenshotUrls.count > 1 {
                s2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
            }

            if appResult.screenshotUrls.count > 2 {
                s3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
            }
        }
    }

    let iconView: UIImageView = {
        let view = UIImageView()
        view.widthAnchor.constraint(equalToConstant: 64).isActive = true
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.layer.cornerRadius = 12.0
        view.clipsToBounds = true
        return view
    }()

    let nameLabel = UILabel(text: "App Name")
    let categoryLabel = UILabel(text: "Photos & Video")
    let ratingsView = RatingView()
    let getBtn: UIButton = .createGetBtn()

    lazy var s1ImageView = self.createScreenShotImgViews()
    lazy var s2ImageView = self.createScreenShotImgViews()
    lazy var s3ImageView = self.createScreenShotImgViews()

    func createScreenShotImgViews() -> UIImageView {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.borderWidth = 0.5
        imgView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imgView.layer.cornerRadius = 8.0
        imgView.clipsToBounds = true
        return imgView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let infoStack = UIStackView(arrangedSubviews: [
            iconView,
            VStack(subviews: [nameLabel, categoryLabel, ratingsView]),
            getBtn
        ])
        infoStack.spacing = 12.0
        infoStack.alignment = .center

        let screenshotStack = UIStackView(arrangedSubviews: [s1ImageView, s2ImageView, s3ImageView])
        screenshotStack.spacing = 12
        screenshotStack.distribution = .fillEqually

        let vStack = VStack(subviews: [infoStack, screenshotStack], spacing: 16.0)

        addSubview(vStack)
        vStack.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
