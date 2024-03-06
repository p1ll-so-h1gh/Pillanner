//
//  TabBarController.swift
//  ExCalendar
//
//  Created by Joseph on 3/4/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        setupTabBar()
    }

    private func setupTabBar() {
        tabBar.backgroundColor = .clear

        let userMainVC = UserMainViewController()
        setupTabBarItem(for: userMainVC, imageName: "tabHome", selectedImageName: "tabHome.fill")

        let pillAddVC = PillAddMainViewController()
        setupTabBarItem(for: pillAddVC, imageName: "tabAdd")

        let calendarVC = CalendarViewController()
        setupTabBarItem(for: calendarVC, imageName: "tabCalendar", selectedImageName: "tabCalendar.fill")

        viewControllers = [userMainVC, pillAddVC, calendarVC]
    }

    private func setupTabBarItem(for viewController: UIViewController, imageName: String, selectedImageName: String? = nil) {
        viewController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)

        if let selectedImageName = selectedImageName {
            viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        }
    }

    // PillAddMainVC 모달 처리
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PillAddMainViewController {
            let pillAddVC = PillAddMainViewController()
            pillAddVC.modalPresentationStyle = .fullScreen
            present(pillAddVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
