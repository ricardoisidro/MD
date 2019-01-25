//
//  AppDelegate.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
//import CryptoSwift
//import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    //MARK: - TabBarController delegate
    // This delegate open the modal view before open the desired view.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        /*let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        */
        if Global.shared.isinSidur {
            return false
        }
        
        if viewController is NewSettingsViewController && !Global.shared.loginOk {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 4
                return false
                
                //192.168.1.171
            }
        }
        if viewController is CardController && !Global.shared.loginOk {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 1
                return false
            }
        }
        
        /*let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            //print("estoy en 0")
            
        }
        if tabBarIndex == 1 {
            //print("estoy en 1")
        }
        if tabBarIndex == 2 {
            //print("estoy en 2")
        }
        if tabBarIndex == 3 {
            //print("estoy en 3")
        }
        if tabBarIndex == 4 {
            //print("estoy en 4")
        
        }*/
     
     
 
 
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            if (rootViewController.responds(to: Selector(("canRotate")))) {
                // Unlock landscape view orientations for this view controller
                return .allButUpsideDown;
            }
        }
        
        // Only allow portrait (standard behaviour)
        return .portrait;
    }
    
    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) {
            return nil
        }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        }
        else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        }
        else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        else {
            return rootViewController
        }
       
    }
    

  
    // This delegate open the modal view after open the desired view.
  /*  private func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) -> Bool {
        //print("entre a otro delegado")
        
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        
      
        
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
           //print("estoy en 0")
        }
        if tabBarIndex == 1 {
            //print("estoy en 1")
            
         /*   if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 1
                return false
            }*/
        }
        if tabBarIndex == 2 {
            //print("estoy en 2")
        }
        if tabBarIndex == 3 {
            //print("estoy en 3")
        }
        if tabBarIndex == 4 {
            //print("estoy en 4")
    
  /*  if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController")  {
    tabBarController.present(popUpVC, animated: true)
    //tabBarController.selectedIndex = 4
    return false
    
    //192.168.1.171
    }*/
        }
      return true
    }*/

    //MARK: - App delegates
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
  //print("Selected view controller")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    
}

