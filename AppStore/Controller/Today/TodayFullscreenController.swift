import UIKit

class TodayFullscreenController: UITableViewController {

    var dismissHandler: (() ->())?
    var todayItem: TodayItem?

    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = UIColor(named: "secondaryGray")!

        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            if todayItem?.cellType == TodayItem.CellType.featuredApp {
                let headerCell = TodayFeaturedAppFullscreenHeaderCell()
                headerCell.todayCell.todayItem = todayItem
                headerCell.todayCell.layer.cornerRadius = 0
                headerCell.onClose = { [unowned self] in
                    headerCell.closeBtn.isHidden = true
                    self.dismissHandler?()
                }

                return headerCell
            }

            let headerCell = TodayFullscreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.onClose = { [unowned self] in
                headerCell.closeBtn.isHidden = true
                self.dismissHandler?()
            }

            return headerCell
        }

        let cell = TodayFullscreenContentCell()
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return TodayController.CELL_SIZE
        }

        return super.tableView(tableView, heightForRowAt: indexPath)
    }

}
