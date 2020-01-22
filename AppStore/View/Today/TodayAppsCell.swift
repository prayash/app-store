import UIKit

class TodayAppsCell: TodayCellItem {
    override var todayItem: TodayItem? {
        didSet {
            categoryLabel.text = todayItem?.category.uppercased()
            titleLabel.text = todayItem?.title
            appsController.results = todayItem?.apps ?? []
            appsController.collectionView.reloadData()
        }
    }

    let categoryLabel = UILabel(text: "THE DAILY LIST", font: .boldSystemFont(ofSize: 16))
    let titleLabel = UILabel(text: "Start a Quick Conversation", font: .boldSystemFont(ofSize: 28), numberOfLines: 2)
    let appsController = TodayAppsController(mode: .small)

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = VStack(subviews: [
            categoryLabel,
            titleLabel,
            appsController.view
        ], spacing: 12)

        backgroundColor = UIColor(named: "secondaryGray")!
        layer.cornerRadius = 12

        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
