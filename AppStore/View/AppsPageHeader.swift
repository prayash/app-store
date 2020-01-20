import UIKit

class AppsPageHeader: UICollectionReusableView {

    let appsHeaderController = AppsHeaderController()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(appsHeaderController.view)
        appsHeaderController.view.fillSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
