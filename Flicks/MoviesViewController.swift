//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/10/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit
import AFNetworking
import JTProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var endpoint: String!
    var detail: Bool = true
    
    @IBOutlet weak var viewTypeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        networkRequest(self.endpoint)
        
        
    }
    
    func networkRequest(endpoint: String) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            self.tableView.reloadData()
                            JTProgressHUD.hide()
                    }
                }
        });
        task.resume()
    }

    
    override func viewWillAppear(animated: Bool) {
        if movies == nil {
            JTProgressHUD.show()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView - Configure the UITableView
    
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            if detail {
                return movies.count
            }
            else {
                return movies.count/2
            }
            
        }
        else {
            return 0
        }
    }
    // heightForRowAtIndexPath
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if detail {
            return 120
        }
        else {
            return 268
        }
    }
    // configure cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: MovieCell
        
        if detail {
            cell = tableView.dequeueReusableCellWithIdentifier("MovieCellDetail", forIndexPath:  indexPath) as! MovieCell
            
            
            
            let movie = movies![indexPath.row]
            let title = movie["title"] as? String
            let overview = movie["overview"] as? String
            cell.titleLabel.text = title
            cell.overviewLabel.text = overview
            
            let baseUrl = "http://image.tmdb.org/t/p/w500/"
            
            if let posterPath = movie["poster_path"] as? String {
                let posterURL = NSURL(string: baseUrl + posterPath)
                cell.posterImage.setImageWithURL(posterURL!)
            }
            
            let year = (movie["release_date"] as! NSString).substringWithRange(NSRange(location: 0, length: 4))
            let rating = movie["vote_average"] as! Double
            cell.yearLabel.text = String(year)
            cell.ratingLabel.text = String(format: "%.1f", rating)
            ratingColor(cell.ratingLabel, rating: rating)
            
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("MovieCellIcon", forIndexPath:  indexPath) as! MovieCell
            cell.selectionStyle = .None
            let index = 2*indexPath.row
            let movie1 = movies![index]
            let movie2 = movies![index + 1]
            
            let year1 = (movie1["release_date"] as! NSString).substringWithRange(NSRange(location: 0, length: 4))
            let year2 = (movie1["release_date"] as! NSString).substringWithRange(NSRange(location: 0, length: 4))
            
            let rating1 = movie1["vote_average"] as! Double
            let rating2 = movie1["vote_average"] as! Double
            
            let posterPath1 = movie1["poster_path"] as! String
            let posterPath2 = movie2["poster_path"] as! String
            
            let baseUrl = "http://image.tmdb.org/t/p/w500/"
            let imageUrl1 = NSURL(string: baseUrl + posterPath1)
            let imageUrl2 = NSURL(string: baseUrl + posterPath2)
            
            cell.posterImage1.setImageWithURL(imageUrl1!)
            cell.posterImage2.setImageWithURL(imageUrl2!)
            
            cell.yearLabel1.text = String(year1)
            cell.yearLabel2.text = String(year2)
            
            cell.ratingLabel1.text = String(format: "%.1f", rating1)
            cell.ratingLabel2.text = String(format: "%.1f", rating2)
            
            ratingColor(cell.ratingLabel1, rating: rating1)
            ratingColor(cell.ratingLabel2, rating: rating2)
        }
        
        return cell
    }

    // MARK: Helper methods
    
    func ratingColor(label: UILabel, rating: Double) {
        if rating > 6 {
            label.backgroundColor = UIColor.yellowColor()
            label.textColor = UIColor.blackColor()
        }
        else if rating > 4 {
            label.backgroundColor = UIColor.greenColor()
            label.textColor = UIColor.whiteColor()
        }
        else {
            label.backgroundColor = UIColor.redColor()
            label.textColor = UIColor.whiteColor()
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
        view.endEditing(true)
    }
    
    // MARK: Actions
    
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
        
        tableView.reloadData()
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if detail {
            let cell = sender as! UITableViewCell
            let indexpath = tableView.indexPathForCell(cell)
            let movie = movies![indexpath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.movie = movie
        }
        else {
            let gestureRecognizer = sender as! UIGestureRecognizer
            
        }
        
    }
}
