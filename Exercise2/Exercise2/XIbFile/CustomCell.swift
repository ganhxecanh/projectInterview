//
//  CustomCell.swift
//  Exercise2
//
//  Created by Hung Vuong on 5/27/20.
//  Copyright © 2020 Hung Vuong. All rights reserved.
//

import UIKit
import Kingfisher

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var personImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with imageInfo: ImageInfo)  {
        nameLabel.text = imageInfo.name
        emailLabel.text = imageInfo.email
        personImageVIew.kf.setImage(with: URL(string: imageInfo.avatar))
    }
}

