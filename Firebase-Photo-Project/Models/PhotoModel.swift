//
//  PhotoModel.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/3/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import Foundation

struct PhotoPost {
    //let photoName: String
    let photoId: String
    let postedDate: Date
    let sellerName: String
    let accountId: String
    let imageURL: String
    let photoName: String
}

extension PhotoPost {
    init(_ dictionary: [String: Any]) {
       // self.photoName = dictionary["photoName"] as? String ?? "no name"
        self.photoId = dictionary["photoId"] as? String ?? "no id"
        self.postedDate = dictionary["postedDate"] as? Date ?? Date()
        self.sellerName = dictionary["sellerName"] as? String ?? "no name"
        self.accountId = dictionary["accountId"] as? String ?? "no id"
        self.imageURL = dictionary["imageURL"] as? String ?? "no url"
        self.photoName = dictionary["photoName"] as? String ?? "no caption"
        
    }
}
