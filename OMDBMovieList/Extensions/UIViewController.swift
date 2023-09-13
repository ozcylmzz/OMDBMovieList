//
//  UIViewController.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import UIKit

extension UIViewController {
    
    func getDefaultAlertController(with alertContent: AlertContentConfig?) -> UIViewController {
        let controller: DefaultAlertController = UIStoryboard.common.instantiateViewController()
        controller.alertContent = alertContent
        return controller
    }
    
    func addNavigationTitle(_ title: String, textColor: UIColor? = StyleManager.colors.navigationBarTitleColor) {
        let label = UILabel(frame: CGRect(x: 0, y: 0.0, width: Double((title.count * 20)), height: 44.0))
        label.text = title
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        label.textColor = textColor
        label.textAlignment = NSTextAlignment.left
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.title = ""
    }
}

extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        return viewController
    }
}
