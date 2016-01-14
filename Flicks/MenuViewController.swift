//
//  MainViewController.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/12/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var checked: [Bool]!
    let CellIdentifier = "CategoryCell"
    
    let movieCategory = ["Now Playing","Top Rated", "Latest", "Popular", "Upcoming"]
    let tvCategory = ["On the Air", "Airing Today", "Top Rated", "Popular"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checked = [Bool](count: movieCategory.count + tvCategory.count, repeatedValue: false)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        self.navigationController?.navigationBar.barStyle = .BlackTranslucent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView - Configure the UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "Movie Categories"
        }
        else {
            return "TV Show Categories"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.blackColor()
        header.textLabel!.textColor = UIColor.whiteColor()
        header.alpha = 0.85
    }
    
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return movieCategory.count
        }
        else {
            return tvCategory.count
        }
    }
    // didselectrow
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            checked[indexPath.row] = !checked[indexPath.row]
        }
        else {
            checked[indexPath.row + movieCategory.count] = !checked[indexPath.row + movieCategory.count]
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        if(indexPath.section == 0) {
            cell.textLabel?.text = movieCategory[indexPath.row]
            if checked[indexPath.row] {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        else {
            cell.textLabel?.text = tvCategory[indexPath.row]
            if checked[indexPath.row + movieCategory.count] {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        cell.backgroundColor = UIColor.darkGrayColor()
        cell.tintColor = UIColor.orangeColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
        
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
