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
    let displayName: String
    let accountId: String
    let imageURL: String
    let caption: String
}

extension PhotoPost {
    init(_ dictionary: [String: Any]) {
       // self.photoName = dictionary["photoName"] as? String ?? "no name"
        self.photoId = dictionary["photoId"] as? String ?? "no id"
        self.postedDate = dictionary["postedDate"] as? Date ?? Date()
        self.displayName = dictionary["displayName"] as? String ?? "no name"
        self.accountId = dictionary["accountId"] as? String ?? "no id"
        self.imageURL = dictionary["imageURL"] as? String ?? "no url"
        self.caption = dictionary["caption"] as? String ?? "no caption"
        
    }
}
