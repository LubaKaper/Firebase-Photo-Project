//
//  FeedViewController.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/6/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
    private var posts = [PhotoPost]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "FeedCell", bundle: nil), forCellWithReuseIdentifier: "feedCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.itemsCollection).addSnapshotListener({[weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                     self?.showAlert(title: "Firestore Error", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let posts = snapshot.documents.map { PhotoPost($0.data())}
                self?.posts = posts
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }
    
}
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCell else {
            fatalError("Could not downcast to FeedCell")
        }
        let post = posts[indexPath.row]
        cell.configureCell(for: post)
        return cell
    }
    
    
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let spacingBetweenItems: CGFloat = 11
        let numberOfItems: CGFloat = 1
        let totalSpacing: CGFloat = (2 * spacingBetweenItems) + (numberOfItems - 1) * numberOfItems
        let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
        let itemHeight: CGFloat = maxSize.height * 0.50
        return CGSize(width: itemWidth, height: itemHeight)
       // let maxSize: CGSize = UIScreen.main.bounds.size
//        let itemWidth: CGFloat = UIScreen.main.bounds.size.width * 0.8//maxSize.width * 0.9
//        let itemHeight: CGFloat = UIScreen.main.bounds.size.height * 0.5//maxSize.height * 0.4
//        return CGSize(width: 200, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell was selected")
        let selectedPost = posts[indexPath.row]
        
        let storyboard = UIStoryboard(name: "MainView", bundle: nil)
        let detaiVC = storyboard.instantiateViewController(identifier: "DetailViewController") { coder in
            return DetailViewController(coder: coder, selectedPost)
        }
       // present(UINavigationController(rootViewController: detaiVC), animated: true, completion: nil)
        //detaiVC.selectedEntry = selectedPost
       navigationController?.pushViewController(detaiVC, animated: true)
        //present(detaiVC, animated: true)
    }
    
}
