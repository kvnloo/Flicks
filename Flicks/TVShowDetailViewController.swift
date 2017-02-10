//
//  TVShowDetailViewController.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/14/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit

class TVShowDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    var tvShow: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let name = tvShow["name"] as! String
        let overview = tvShow["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500/"
        
        if let posterPath = tvShow["poster_path"] as? String {
            let posterURL = NSURL(string: baseUrl + posterPath)
            posterImageView.setImageWithURL(posterURL!)
        }
        
        let airDate = (tvShow["first_air_date"] as! NSString)
        let rating = tvShow["vote_average"] as! Double
        
        titleLabel.text = name
        airDateLabel.text = String(airDate)
        ratingLabel.text = String(format: "%.1f", rating)
        ratingColor(ratingLabel, rating: rating)
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

