import UIKit

/**
 A convenient UIImageView to load and cache images.
 */
open class CachedImageView: UIImageView {

    public static let cache = NSCache<NSString, DiscardableImageCacheItem>()

    open var shouldUseEmptyImage = true

    private var urlStringForChecking: String?
    private var emptyImage: UIImage?

    public init(cornerRadius: CGFloat = 0, emptyImage: UIImage? = nil) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.emptyImage = emptyImage
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Easily load an image from a URL string and cache it to reduce network overhead later.
     - parameter urlString: The url location of your image, usually on a remote server somewhere.
     - parameter completion: Optionally execute some task after the image download completes
     */
    open func loadImage(urlString: String, completion: (() -> ())? = nil) {
        image = nil

        self.urlStringForChecking = urlString
        let urlKey = urlString as NSString

        if let cachedItem = CachedImageView.cache.object(forKey: urlKey) {
            image = cachedItem.image
            completion?()
            return
        }

        guard let url = URL(string: urlString) else {
            if shouldUseEmptyImage {
                image = emptyImage
            }

            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, res, error in
            if let err = error {
                print("Error loading image: ", err)
                return
            }

            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    let cacheItem = DiscardableImageCacheItem(image: image)
                    CachedImageView.cache.setObject(cacheItem, forKey: urlKey)

                    if urlString == self?.urlStringForChecking {
                        self?.image = image
                        completion?()
                    }
                }
            }

        }.resume()
    }
}

open class DiscardableImageCacheItem: NSObject, NSDiscardableContent {

    private(set) public var image: UIImage?
    var accessCount: UInt = 0

    public init(image: UIImage) {
        self.image = image
    }

    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }

        accessCount += 1
        return true
    }

    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }

    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }

    public func isContentDiscarded() -> Bool {
        return image == nil
    }

}
