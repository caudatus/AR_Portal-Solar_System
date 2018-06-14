//
//  AppDelegate.swift
//  AR Potal - Solar
//
//  Created by Seo JaeHyeong on 15/05/2018.
//  Copyright © 2018 Seo Jaehyeong. All rights reserved.
//
import ARKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      return true
   }

   
   func applicationWillResignActive(_ application: UIApplication) {
      if let viewController = self.window?.rootViewController as? MainViewController {
         viewController.blurView.isHidden = false
      }
   }


   func applicationDidBecomeActive(_ application: UIApplication) {
      if let viewController = self.window?.rootViewController as? MainViewController {
         viewController.blurView.isHidden = true
         viewController.restartExperience()
      }
   }



}

