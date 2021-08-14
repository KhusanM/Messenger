//
//  AppDelegate.swift
//  Messenger
//
//  Created by Kh's MacBook on 10.08.2021.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        let vc = UINavigationController(rootViewController: MainVC(nibName: "MainVC", bundle: nil))
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        
        
        return true
    }


}

