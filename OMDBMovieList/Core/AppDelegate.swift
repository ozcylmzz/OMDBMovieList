//
//  AppDelegate.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        ReachabilityManager.shared.startMonitoring()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ReachabilityManager.shared.stopMonitoring()
    }
}

