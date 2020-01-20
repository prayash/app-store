import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont = .systemFont(ofSize: 17), numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
    }
}
