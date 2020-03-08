//
//  DatabaseService.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/3/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    static let itemsCollection = "items"
    
    // lets get a reference to the firebase firestore database
    private let db = Firestore.firestore()
//    let photoName: String
//    let photoId: String
//    let postedDate: Date
//    let accountName: String
//    let accountId: String
//    let imageURL: String
    
    public func createItem(photoName: String, displayName: String, completion: @escaping (Result <String,Error>) ->()){
         
        guard let user = Auth.auth().currentUser else { return }
        
        // generate a document for the "items" collection (could be any piece od data like product, like, photo...)
        let documentRef = db.collection(DatabaseService.itemsCollection).document()
        
        // create document in our items collection
        // data we pass has to be key:value format
        
        db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["photoName": photoName,  "photoId": documentRef.documentID, "postedDate":Timestamp(date: Date()), "sellerName":displayName,"accountId":user.uid]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentRef.documentID))
            }
        }
//        db.collection(DatabaseService.itemsCollection).document(documentRef.documentID).setData(["itemName":itemName, "price": price, "itemId":documentRef.documentID, "listedDate":Timestamp(date: Date()), "sellerName":displayName,"sellerId":user.uid, "categoryName":category.name]) { (error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(documentRef.documentID))
//            }
//        }
    }
}
