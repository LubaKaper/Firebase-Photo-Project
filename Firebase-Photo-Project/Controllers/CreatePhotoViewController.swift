//
//  CreatePhotoViewController.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/3/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreatePhotoViewController: UIViewController {
    
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
    @IBOutlet weak var captionTextField: DesignableTextField!
    
    private var dbService = DatabaseService()
    
    private var storageService = StorageService()
    
    private  lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    private var selectedImage: UIImage? {
        didSet {
            postImageView.image = selectedImage
        }
    }
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOptions))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Post"
        
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(longPressGesture)
       
    }
    
    @objc private func showPhotoOptions() {
           let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
           let camerAction = UIAlertAction(title: "Camera", style: .default) { alertAction in
               self.imagePickerController.sourceType = .camera
               self.present(self.imagePickerController, animated: true)
           }
           let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
               self.imagePickerController.sourceType = .photoLibrary
               self.present(self.imagePickerController, animated: true)
           }
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           if UIImagePickerController.isSourceTypeAvailable(.camera){
           alertController.addAction(camerAction)
           }
           
           alertController.addAction(photoLibrary)
           alertController.addAction(cancelAction)
           present(alertController, animated: true)
       }
    

    @IBAction func uploadImageButtonPressed(_ sender: UIBarButtonItem) {
        guard let caption = captionTextField.text,
            let selectedImage = selectedImage else {
                showAlert(title: "Missing image", message: "image is required for the post")
                return
        }
        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete profile", message: "Please complete your Profile")
            return
        }
        // resize image before uploadimg to storage
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: postImageView.bounds)
        
        dbService.createItem(caption: caption, displayName: displayName) {[weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error creating Item", message: "Sorry something went wrong: \(error.localizedDescription)")
                }
            case .success(let documentId):
                self?.uploadPhoto(photo: resizedImage, documentId: documentId)
                
            }
        }
        // dismisses view
         dismiss(animated: true)
    }
    
    private func uploadPhoto(photo: UIImage, documentId: String) {
        storageService.uploadPhoto( itemId: documentId, image: photo) { [weak self](result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                        self?.showAlert(title: "error uploading photo", message: "\(error.localizedDescription)")
                    }
                case .success(let url):
                    self?.updateItemImageURL(url, documentId: documentId)
            }
        }
    }
    private func updateItemImageURL( _ url: URL, documentId: String) {
        Firestore.firestore().collection(DatabaseService.itemsCollection).document(documentId).updateData(["imageURL" : url.absoluteString]) {[weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                                   self?.showAlert(title: "Failed to update item", message: "\(error.localizedDescription)")
                               }
                           } else {
                               print("all went well with update")
                               DispatchQueue.main.async {
                                   self?.dismiss(animated: true)
                               }
            }
        }
    }
    

}
extension CreatePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not attain original image")
        }
        selectedImage = image
        dismiss(animated: true)
    }
}
