//
//  MovieCell.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/10/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var posterImage1: UIImageView!
    @IBOutlet weak var posterImage2: UIImageView!
    @IBOutlet weak var yearLabel1: UILabel!
    @IBOutlet weak var ratingLabel1: UILabel!
    @IBOutlet weak var yearLabel2: UILabel!
    @IBOutlet weak var ratingLabel2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
