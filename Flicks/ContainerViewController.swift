//
//  ContainViewController.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/12/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    
    
    var leftMenuWidth:CGFloat = 0
    var menuOpen: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ensure leftMenuWidth is the width of the menuContainerView
        leftMenuWidth = menuContainerView.frame.width
        
        // Apply Shadow
        applyPlainShadow(mainContainerView)
        
        // Do any additional setup after loading the view.
        // Tab bar controller's child pages have a top-left button toggles the menu
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenuViaNotification", name: "closeMenuViaNotification", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Cleanup notifications added in viewDidLoad
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func toggleMenu(){
        scrollView.contentOffset.x == 0  ? openMenu() : closeMenu()
    }
    
    // This wrapper function is necessary because closeMenu params do not match up with Notification
    func closeMenuViaNotification(){
        closeMenu()
    }
    // Use scrollview content offset-x to slide the menu.
    func closeMenu(animated:Bool = true){
        self.view.addSubview(menuContainerView)
        menuContainerView.frame = CGRect(x: 0, y: 0, width: menuContainerView.frame.width, height: menuContainerView.frame.height)
        self.view.sendSubviewToBack(menuContainerView)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
        
        
    }
    
    // Open is the natural state of the menu because of how the storyboard is setup.
    func openMenu(){
        scrollView.setContentOffset(CGPoint(x: -200, y: 0), animated: true)
    }
    
    func applyPlainShadow(view: UIView) {
        let layer = view.layer
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: -15, height: 0)
        layer.shadowOpacity = 0.85
        layer.shadowRadius = 50
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destinationViewController.isKindOfClass(UITabBarController) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let nowPlayingMoviesNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
            let nowPlayingMoviesViewController = nowPlayingMoviesNavigationController.topViewController as! MoviesViewController
            nowPlayingMoviesViewController.endpoint = "movie/now_playing"
            nowPlayingMoviesNavigationController.tabBarItem.title = "Now Playing"
            nowPlayingMoviesNavigationController.tabBarItem.image = UIImage(named: "popular")
            nowPlayingMoviesNavigationController.navigationBar.barStyle = .BlackTranslucent
            
            let upcomingMoviesNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
            let upcomingMoviesViewController = upcomingMoviesNavigationController.topViewController as! MoviesViewController
            upcomingMoviesViewController.endpoint = "movie/upcoming"
            upcomingMoviesNavigationController.tabBarItem.title = "Upcoming"
            upcomingMoviesNavigationController.tabBarItem.image = UIImage(named: "")
            upcomingMoviesNavigationController.navigationBar.barStyle = .BlackTranslucent
            
            let onTheAirTVShowsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TVShowsNavigationController") as! UINavigationController
            let onTheAirTVShowsViewController = onTheAirTVShowsNavigationController.topViewController as! TVShowsViewController
            onTheAirTVShowsViewController.endpoint = "tv/on_the_air"
            onTheAirTVShowsNavigationController.tabBarItem.title = "On The Air"
            onTheAirTVShowsNavigationController.tabBarItem.image = UIImage(named: "")
            onTheAirTVShowsNavigationController.navigationBar.barStyle = .BlackTranslucent
            
            let popularTVShowsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TVShowsNavigationController") as! UINavigationController
            let popularTVShowsViewController = popularTVShowsNavigationController.topViewController as! TVShowsViewController
            popularTVShowsViewController.endpoint = "tv/popular"
            popularTVShowsNavigationController.tabBarItem.title = "Popular"
            popularTVShowsNavigationController.tabBarItem.image = UIImage(named: "")
            popularTVShowsNavigationController.navigationBar.barStyle = .BlackTranslucent
            
            let tabVC = segue.destinationViewController as! UITabBarController
            tabVC.viewControllers = [nowPlayingMoviesNavigationController, upcomingMoviesNavigationController, onTheAirTVShowsNavigationController, popularTVShowsNavigationController]
            tabVC.tabBar.barStyle = .Black
            tabVC.tabBar.tintColor = UIColor.orangeColor()
            
        }
    }
    

}

extension ContainerViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollView.contentOffset.x:: \(scrollView.contentOffset.x)")

        if scrollView.contentOffset.x == -200 {
            scrollView.addSubview(menuContainerView)
            menuContainerView.frame = CGRect(x: -200, y: 0, width: menuContainerView.frame.width, height: menuContainerView.frame.height)
            scrollView.bringSubviewToFront(mainContainerView)
        }

    }
    
    // http://www.4byte.cn/question/49110/uiscrollview-change-contentoffset-when-change-frame.html
    // When paging is enabled on a Scroll View,
    // a private method _adjustContentOffsetIfNecessary gets called,
    // presumably when present whatever controller is called.
    // The idea is to disable paging.
    // But we rely on paging to snap the slideout menu in place
    // (if you're relying on the built-in pan gesture).
    // So the approach is to keep paging disabled.
    // But enable it at the last minute during scrollViewWillBeginDragging.
    // And then turn it off once the scroll view stops moving.
    //
    // Approaches that don't work:
    // 1. automaticallyAdjustsScrollViewInsets -- don't bother
    // 2. overriding _adjustContentOffsetIfNecessary -- messing with private methods is a bad idea
    // 3. disable paging altogether.  works, but at the loss of a feature
    // 4. nest the scrollview inside UIView, so UIKit doesn't mess with it.  may have worked before,
    //    but not anymore.
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollView.pagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollView.pagingEnabled = false
    }
}
