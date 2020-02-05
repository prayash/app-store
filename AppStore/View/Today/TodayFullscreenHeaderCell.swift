import UIKit

class TodayFullscreenHeaderCell: UITableViewCell {

    /// The content of this cell looks identical to the `TodayCell` component.
    let content = TodayCell()

    var onClose: (() -> ())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(content)
        content.fillSuperview()
    }

    @objc func close() {
        onClose?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
