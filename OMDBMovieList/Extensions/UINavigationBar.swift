//
//  UINavigationBar.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation
import UIKit

extension UINavigationBar {
    func setBlurEffect() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        let statusBarHeight: CGFloat = UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? UIApplication.shared.windows.first { $0.isKeyWindow }?.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        
        var blurAnimator: UIViewPropertyAnimator?
        
        let blurViews = self.subviews.filter({ $0.isKind(of: UIVisualEffectView.self) })
        blurViews.forEach { subView in
            subView.removeFromSuperview()
        }
        
        let blurEffectView = UIVisualEffectView()
        blurEffectView.backgroundColor = .clear
        blurEffectView.cornerRadius = cornerRadius
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = blurFrame
        blurEffectView.layer.zPosition = -1
        blurEffectView.isUserInteractionEnabled = false
        addSubview(blurEffectView)
        
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [blurEffectView] in
            blurEffectView.effect = UIBlurEffect(style: .extraLight)
        }
        
        blurAnimator?.fractionComplete = 0.3 // set the blur intensity.
        blurAnimator?.pausesOnCompletion = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            blurAnimator?.pauseAnimation()
            blurAnimator?.stopAnimation(true)
            blurAnimator?.finishAnimation(at: .current)
        }
    }
}

extension UINavigationBar {
    func prepareNavigationBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.tintColor = StyleManager.colors.inactiveGray
        self.topItem?.backBarButtonItem = backButton
    }
}
