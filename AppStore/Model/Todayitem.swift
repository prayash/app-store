import UIKit

struct TodayItem {
    enum CellType: String {
        case article, apps, featuredApp
    }

    let category: String
    let title: String
    let image: UIImage
    let description: String
    let bgColor: UIColor
    let cellType: CellType
    let apps: [Feed.Result]
}
