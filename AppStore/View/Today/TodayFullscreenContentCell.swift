import UIKit

class TodayFullscreenContentCell: UITableViewCell {

    let descriptionLabel: UILabel = {
        let label = UILabel()

        let attributedText = NSMutableAttributedString(string: "Whether you’re stressed out", attributes: [:])

        attributedText.append(NSAttributedString(string: " or just looking to take a little more time for yourself, Oak can help you relax and unwind—and it even offers a little arboreal incentive in the process.", attributes: [.foregroundColor: UIColor.gray]))

        attributedText.append(NSAttributedString(string: "\n\n\nOak has plenty of options.", attributes: [:]))

        attributedText.append(NSAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor: UIColor.gray]))

        attributedText.append(NSAttributedString(string: "\n\n\nHeroic adventure", attributes: [:]))

        attributedText.append(NSAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor: UIColor.gray]))

        attributedText.append(NSAttributedString(string: "\n\n\nOak has plenty of options.", attributes: [:]))

        attributedText.append(NSAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor: UIColor.gray]))

        attributedText.append(NSAttributedString(string: "\n\n\nOak has plenty of options.", attributes: [:]))

        attributedText.append(NSAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor: UIColor.gray]))

        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.attributedText = attributedText
        label.numberOfLines = 0

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        addSubview(descriptionLabel)
        descriptionLabel.fillSuperview(padding: .init(top: 24, left: 24, bottom: 0, right: 24))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
