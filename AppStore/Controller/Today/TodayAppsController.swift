import UIKit

public enum Mode {
    case small, fullScreen
}

class TodayAppsController: UICollectionViewController {

    private let cellId = "cellId"

    var results: [Feed.Result] = []

    private var mode: Mode

    let closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.tintColor = .darkGray
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle

    init(mode: Mode) {
        self.mode = mode
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if mode == .fullScreen {
            view.addSubview(closeBtn)
            closeBtn.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
        }

        configureCollectionView()
    }

    @objc func handleDismiss() {
        self.dismiss(animated: true)
    }

    // MARK: - Collection View

    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isScrollEnabled = mode == .fullScreen
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode == .fullScreen ? results.count : min(results.count, 4)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppRowCell
        cell.app = results[indexPath.item]

        return cell
    }
}

// MARK: - Collection View Flow Layout

extension TodayAppsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 74

        if mode == .fullScreen {
            return .init(width: view.frame.width - 48, height: height)
        }

        return .init(width: view.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullScreen {
            return .init(top: 60, left: 24, bottom: 12, right: 24)
        }

        return .zero
    }
}
