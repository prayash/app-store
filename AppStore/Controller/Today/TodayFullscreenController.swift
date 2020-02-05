import UIKit

class TodayFullscreenController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dismissHandler: (() ->())?
    var item: TodayItem?

    override var prefersStatusBarHidden: Bool { return true }

    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.tintColor = .gray
        return btn
    }()

    let tableView = UITableView(frame: .zero, style: .plain)
    let floatingContainer = UIView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.clipsToBounds = true

        configureTableView()
        configureCloseBtn()
        configureFloatingControl()
    }

    private func configureCloseBtn() {
        view.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        closeBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
    }

    @objc private func handleTap() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainer.transform = .init(translationX: 0, y: -90)
        })
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }

        let translationY = -90 - UIApplication.shared.statusBarFrame.height / 2
        let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.floatingContainer.transform = transform
        })
    }

    private func configureFloatingControl() {
        floatingContainer.layer.cornerRadius = 16
        floatingContainer.clipsToBounds = true
        view.addSubview(floatingContainer)

        floatingContainer.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: 90))

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainer.addSubview(blurView)
        blurView.fillSuperview()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        let imgView = UIImageView(cornerRadius: 16)
        imgView.image = item?.image
        imgView.constrainHeight(constant: 68)
        imgView.constrainWidth(constant: 68)

        let getBtn = UIButton(title: "GET")
        getBtn.setTitleColor(.white, for: .normal)
        getBtn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getBtn.backgroundColor = .darkGray
        getBtn.layer.cornerRadius = 16
        getBtn.constrainWidth(constant: 80)
        getBtn.constrainHeight(constant: 32)

        let stackView = UIStackView(subviews: [
            imgView,
            VStack(subviews: [
                UILabel(text: "Honeydue: Couples Finance", font: .boldSystemFont(ofSize: 18)),
                UILabel(text: "Manage your money together", font: .systemFont(ofSize: 16))
            ], spacing: 4),
            getBtn
        ], customSpacing: 16)

        floatingContainer.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }

    // MARK: - UITableView

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = UIColor(named: "secondaryGray")!

        let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            if item?.cellType == TodayItem.CellType.featuredApp {
                let headerCell = TodayFeaturedAppFullscreenHeaderCell()
                headerCell.todayCell.todayItem = item
                headerCell.todayCell.layer.cornerRadius = 0
                return headerCell
            }

            let headerCell = TodayFullscreenHeaderCell()
            headerCell.content.todayItem = item
            headerCell.content.layer.cornerRadius = 0
            return headerCell
        }

        let cell = TodayFullscreenContentCell()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.CELL_SIZE
        }

        return UITableView.automaticDimension
    }

    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }

}
