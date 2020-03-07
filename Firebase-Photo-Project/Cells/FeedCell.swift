//
//  FeedCell.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/6/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCell: UICollectionViewCell {
    
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    public func configureCell(for post: PhotoPost) {
        postImageView.kf.setImage(with: URL(string: post.imageURL))
        captionLabel.text = post.caption
        userNameLabel.text = "@\(post.displayName)"
        dateLabel.text = post.postedDate.description
    }
    
}
