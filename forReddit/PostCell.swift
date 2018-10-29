//
//  PostCell.swift
//  forReddit
//
//  Created by jacappsios on 10/26/18.
//  Copyright © 2018 mdwdev. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
