//
//  FlicksTabBarController.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/11/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit

class FlicksTabBarController: UITabBarController {
    
    var detail: Bool = true
    
    
    @IBOutlet weak var viewTypeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor.darkGrayColor()
        self.tabBar.tintColor = UIColor.orangeColor()
        //self.tabBarController?.
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func switchAction(sender: AnyObject) {
        if detail {
            let image: UIImage = UIImage(named: "detailView.png")!
            viewTypeButton.image = image
        }
        else {
            let image: UIImage = UIImage(named: "albumView.png")!
            viewTypeButton.image = image
        }
        detail = !(detail)
        
        
        (self.viewControllers![0] as! PopularMoviesViewController).detail = self.detail
        (self.viewControllers![1] as! TopRatedViewController).detail = self.detail
        
        if self.selectedIndex == 0 {
            (self.viewControllers![self.selectedIndex] as! PopularMoviesViewController).tableView.reloadData()
        }
        else {
            (self.viewControllers![self.selectedIndex] as! TopRatedViewController).tableView.reloadData()
        }
    }
}
