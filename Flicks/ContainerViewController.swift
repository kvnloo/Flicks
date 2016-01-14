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
    
    
    var leftMenuWidth:CGFloat = 2
    var menuOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ensure leftMenuWidth is the width of the menuContainerView
        leftMenuWidth = menuContainerView.frame.width
        // Initially close menu programmatically.  This needs to be done on the main thread initially in order to work.
        
        dispatch_async(dispatch_get_main_queue()) {
            self.closeMenu(false)
        }
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
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    // This wrapper function is necessary because
    // closeMenu params do not match up with Notification
    func closeMenuViaNotification(){
        closeMenu()
    }
    
    // Use scrollview content offset-x to slide the menu.
    func closeMenu(animated:Bool = true){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
    }
    
    // Open is the natural state of the menu because of how the storyboard is setup.
    func openMenu(){
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContainerViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollView.contentOffset.x:: \(scrollView.contentOffset.x)")
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
