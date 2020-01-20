import UIKit

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
    }

    static func createGetBtn() -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle("GET", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 28).isActive = true
        btn.backgroundColor = UIColor(named: "getBtn")
        btn.layer.cornerRadius = 28 / 2
        return btn
    }
}
