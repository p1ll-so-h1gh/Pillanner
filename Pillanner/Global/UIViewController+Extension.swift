//
//  UIViewController+Extension.swift
//  Pillanner
//
//  Created by 윤규호 on 3/18/24.
//

import UIKit
extension UIViewController {
    func popToRootViewController() {
        guard let window = UIApplication.shared.windows.first,
              var topViewController = window.rootViewController else {
            return
        }
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        if let navigationController = topViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        } else if let tabBarController = topViewController as? UITabBarController,
                  let selectedViewController = tabBarController.selectedViewController as? UINavigationController {
            selectedViewController.popToRootViewController(animated: true)
        }
    }
}
