import UIKit

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UIView {
//    func iconWithWrapper() -> UIView {
//        let imageViewWrapper = UIView(frame: imageView.frame)
//        imageViewWrapper.constrainWidth(constant: 64)
//        imageViewWrapper.constrainHeight(constant: 64)
//        imageViewWrapper.addSubview(imageView)
//        imageViewWrapper.layer.cornerRadius = 8.0
//        imageViewWrapper.layer.borderWidth = 1.0
//        imageViewWrapper.layer.borderColor = UIColor(white: 0.7, alpha: 0.5).cgColor
//        imageView.fillSuperview()
//    }
}
