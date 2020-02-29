//
//  NewCell.swift
//  NewFeedApp
//
//  Created by stl-012 on 19/09/18.
//  Copyright © 2018 stl-012. All rights reserved.
//

import UIKit

class NewCell: UICollectionViewCell {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        newsTitle.font = UIFont.systemFont(ofSize: 15.0)
//        newsDesc.font = UIFont.systemFont(ofSize: 15.0)
        
        // Initialization code
    }
    
    

}
