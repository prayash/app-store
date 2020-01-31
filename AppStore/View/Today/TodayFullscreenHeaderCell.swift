import UIKit

class TodayFullscreenHeaderCell: UITableViewCell {

    /// The content of this cell looks identical to the `TodayCell` component.
    let content = TodayCell()

    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.tintColor = .gray
        return btn
    }()

    var onClose: (() -> ())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(content)
        content.fillSuperview()

        addSubview(closeBtn)
        closeBtn.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 44, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 38))
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
    }

    @objc func close() {
        onClose?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
