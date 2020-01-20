import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            containerize(for: TodayController(), title: "Today", icon: "today"),
            containerize(for: AppsPageController(), title: "Apps", icon: "apps"),
            containerize(for: SearchController(), title: "Search", icon: "search")
        ]
    }

    private func containerize(for vc: UIViewController, title: String, icon: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)

        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: icon)
        navController.navigationBar.prefersLargeTitles = true
        vc.view.backgroundColor = .white
        vc.navigationItem.title = title

        return navController
    }

}
