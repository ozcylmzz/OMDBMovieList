//
//  UINavigationController.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation
import UIKit

extension UINavigationController {
    enum navBarStatus: String { case opaque, transparent }
    
    func prepareNavigationBar(status: navBarStatus, blurEffect: Bool = true ) {
        switch status {
        case .opaque:
            prepareOpaqueNavigationBar()
        case .transparent:
            prepareTransparentNavigationBar(blurEffect: blurEffect)
        }
    }
    
    func prepareOpaqueNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navigationBar.backgroundColor = StyleManager.colors.background
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = nil // line
        navBarAppearance.titleTextAttributes = [.foregroundColor: StyleManager.colors.appForegroundColor, .font: UIFont(name: "HelveticaNeue-Bold", size: 22)!]
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.layoutIfNeeded()
        navigationBar.tintColor = StyleManager.colors.inactiveGray
    }
    
    func prepareTransparentNavigationBar(blurEffect: Bool) {
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .default
        navigationBar.backgroundColor = .clear
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = nil // line
        navBarAppearance.titleTextAttributes = [.foregroundColor: StyleManager.colors.appForegroundColor, .font: UIFont(name: "HelveticaNeue-Bold", size: 22)!]
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.layoutIfNeeded()
        
        if blurEffect {
            navigationBar.setBlurEffect()
        }
    }
}
