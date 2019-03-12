//
//  AppDelegate.swift
//  Project27
//
//  Created by robert on 2/21/19.
//  Copyright © 2019 Mejia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = ViewController() 
    window?.makeKeyAndVisible()
    return true
  }
}

