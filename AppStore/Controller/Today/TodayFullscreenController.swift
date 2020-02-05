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

    private func configureFloatingControl() {
        print("Hello")
        let floatingContainer = UIView()
        floatingContainer.backgroundColor = .systemRed
        view.addSubview(floatingContainer)
        floatingContainer.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .init(width: 0, height: 100))
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
