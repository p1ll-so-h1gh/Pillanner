//
//  TabBarController.swift
//  ExCalendar
//
//  Created by Joseph on 3/4/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        tabBar.backgroundColor = .clear

        let userMainVC = UINavigationController(rootViewController: UserMainViewController())
        userMainVC.tabBarItem.image = UIImage(named: "tabHome")?.withRenderingMode(.alwaysOriginal)
        userMainVC.tabBarItem.selectedImage = UIImage(named: "tabHome.fill")?.withRenderingMode(.alwaysOriginal)

        let pillAddVC = UINavigationController(rootViewController: PillAddMainViewController())
        pillAddVC.tabBarItem.image = UIImage(named: "tabAdd")?.withRenderingMode(.alwaysOriginal)

        let calendarVC = CalendarViewController()
        calendarVC.tabBarItem.image = UIImage(named: "tabCalendar")?.withRenderingMode(.alwaysOriginal)
        calendarVC.tabBarItem.selectedImage = UIImage(named: "tabCalendar.fill")?.withRenderingMode(.alwaysOriginal)

        viewControllers = [userMainVC, pillAddVC, calendarVC]
    }

    private func createNavigationController(for viewController: UIViewController, title: String, imageName: String, tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)

        // assets 이미지 사용
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)

        navController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: tag)
        return navController
    }
}
