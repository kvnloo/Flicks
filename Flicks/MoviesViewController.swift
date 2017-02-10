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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var endpoint: String!
    var detail: Bool = true
    var tabBarItemTitle: String!
    
    
    @IBOutlet weak var viewTypeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        networkRequest(self.endpoint)
        
        //collectionView.registerClass(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCellIcon")
        collectionView.backgroundColor = myVariables.backgroundColor
        if detail {
            collectionView.hidden = true
            tableView.hidden = false
        }
        else {
            collectionView.hidden = false
            tableView.hidden = true
        }
        
    }
    
    func networkRequest(endpoint: String) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/\(endpoint)?api_key=\(apiKey)")
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
                            self.collectionView.reloadData()
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
                return movies.count
        }
        else {
            return 0
        }
    }
    // heightForRowAtIndexPath
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    // configure cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MovieCell = tableView.dequeueReusableCellWithIdentifier("MovieCellDetail", forIndexPath:  indexPath) as! MovieCell
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
        cell.selectionStyle = .None
        return cell
    }
    
    
    // MARK: CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCellIcon", forIndexPath: indexPath) as! MovieCollectionViewCell
        let movie = movies![indexPath.row]
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        print(cell.heightAnchor)
        cell.posterImage.setImageWithURL(imageUrl!)
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
    /*
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    */
    func onRefresh() {
        networkRequest(self.endpoint)
        self.refreshControl.endRefreshing()
        
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
            tableView.hidden = true
            collectionView.hidden = false
        }
        else {
            let image: UIImage = UIImage(named: "albumView.png")!
            viewTypeButton.image = image
            tableView.hidden = false
            collectionView.hidden = true
        }
        detail = !(detail)
        
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.a
        if detail {
            let cell = sender as! UITableViewCell
            let indexpath = tableView.indexPathForCell(cell)
            let movie = movies![indexpath!.row]
            
            let detailViewController = segue.destinationViewController as! MovieDetailViewController
            detailViewController.movie = movie
        }
        else {
            let cell = sender as! UICollectionViewCell
            let indexpath = collectionView.indexPathForCell(cell)
            let movie = movies![indexpath!.row]
            
            let detailViewController = segue.destinationViewController as! MovieDetailViewController
            detailViewController.movie = movie
        }
    }
}
