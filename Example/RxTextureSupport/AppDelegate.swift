//
//  AppDelegate.swift
//  RxTextureSupport
//
//  Created by hongda1y on 07/10/2023.
//  Copyright (c) 2023 hongda1y. All rights reserved.
//

import UIKit
import TextureSwiftSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        initApp()
        return true
    }


    private func initApp(){
        let app = MainViewController()
        window?.rootViewController = ASDKNavigationController(rootViewController: app)
        window?.makeKeyAndVisible()
    }
    
}

