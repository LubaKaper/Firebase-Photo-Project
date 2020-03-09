//
//  DetailViewController.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/9/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    @IBOutlet weak var submitedByLabel: UILabel!
    
    
    @IBOutlet weak var captionLabel: UILabel!
    
    private var selectedEntry: PhotoPost
    
    // coder here BECAUSE IT IS STORYBOARD, NOT PROGRAMMATIC. NO STORYBOARD-NO CODER
    init?(coder: NSCoder, _ selectedEntry: PhotoPost){
        self.selectedEntry = selectedEntry
        super.init(coder: coder)

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has  not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
       updateUI()
        
    }
    
   public func updateUI() {
  submitedByLabel.text = selectedEntry.sellerName
        captionLabel.text = selectedEntry.photoName
        detailImageView.kf.setImage(with:URL(string: selectedEntry.imageURL))
    }
    

}
