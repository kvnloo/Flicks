//
//  AppDelegate.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/10/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var checked: [[Bool]]!
    var checkedKey:String = "CHECKED_CATEGORIES"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let defaults = NSUserDefaults.standardUserDefaults()
        let checked = defaults.objectForKey(checkedKey)
        
        if checked == nil {
            myVariables.checked = [[true, false, false, true], [true, false, false, true]]
        }
        else {
            myVariables.checked = checked as! [[Bool]]
        }
        print("app started")
        print(myVariables.checked)
        defaults.setObject(myVariables.checked, forKey: checkedKey)
        
        
        /*
        //window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowPlayingNavigationController = storyboard.instantiateViewControllerWithIdentifier("FlicksNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        nowPlayingViewController.endpoint = "now_playing"
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "popular")
        nowPlayingNavigationController.navigationBar.barStyle = .BlackTranslucent
        
        let topRatedNavigationController = storyboard.instantiateViewControllerWithIdentifier("FlicksNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        topRatedViewController.endpoint = "top_rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "topRated")
        
        topRatedNavigationController.navigationBar.barStyle = .BlackTranslucent
        
        //window?.rootViewController = tabBarController
        /*
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
        tabBarController.tabBar.barStyle = .Black
        tabBarController.tabBar.tintColor = UIColor.orangeColor()
        */
        
        
        //let containerViewController = storyboard.instantiateViewControllerWithIdentifier("ContainerViewController") as! ContainerViewController
        //let mainContainerView = containerViewController.mainContainerView
        
        
        //window?.makeKeyAndVisible()
        */
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //NSNotificationCenter.defaultCenter().postNotificationName("appDidEnterBackground", object: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(myVariables.checked, forKey: checkedKey)
        defaults.synchronize()
        print("app closing")
        print(myVariables.checked)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        
        
    }


}

