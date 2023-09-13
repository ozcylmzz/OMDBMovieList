//
//  LottieAnimations.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation
import Lottie

class LottieAnimations {
    
    let animationView =  LottieAnimationView()
    static let shared = LottieAnimations()
    
    private init() {
        if let animation = LottieAnimation.named(animation) {
            animationView.animation = animation
            animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
        }
    }
    
    func startAnimation() {
        animationView.play()
    }
    
    func pauseAnimation() {
        animationView.pause()
    }
    
    func stopAnimation() {
        animationView.stop()
    }
}
