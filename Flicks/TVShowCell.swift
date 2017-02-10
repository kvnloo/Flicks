//
//  TVShowCell.swift
//  Flicks
//
//  Created by Kevin Rajan on 1/14/16.
//  Copyright © 2016 veeman961. All rights reserved.
//

import UIKit

class TVShowCell: UITableViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImage1: UIImageView!
    @IBOutlet weak var posterImage2: UIImageView!
    @IBOutlet weak var airDateLabel1: UILabel!
    @IBOutlet weak var ratingLabel1: UILabel!
    @IBOutlet weak var ratingLabel2: UILabel!
    @IBOutlet weak var airDateLabel2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
