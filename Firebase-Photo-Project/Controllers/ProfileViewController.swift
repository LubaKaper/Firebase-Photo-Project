//
//  ProfileViewController.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/3/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    
    
    @IBOutlet weak var logOutButton: DesignableButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    
    @IBOutlet weak var displayNameTextField: DesignableTextField!
    
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            profileImageView.image = selectedImage
        }
    }
    
    private let storageService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        displayNameTextField.delegate = self
       updateUI()
    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        displayNameTextField.text = "\(user.displayName ?? "no name")"
        emailLabel.text = user.email
        // add photo
        profileImageView.kf.setImage(with: user.photoURL)
        logOutButton.setTitle("Logout from @\(user.displayName ?? "no name")", for: .normal)
    }
    
    
    @IBAction func editImageButtonPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Choose Photo Action", message: nil, preferredStyle: .actionSheet)
        let camerAction = UIAlertAction(title: "Camera", style: .default){ alerAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default){ alerAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
        alertController.addAction(camerAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    
    @IBAction func updateProfileButtonPressed(_ sender: UIButton) {
        
        guard let displayName = displayNameTextField.text,
            !displayName.isEmpty,
            let selectedImage = selectedImage else {
                print("missing fields")
                return
        }
        guard let user = Auth.auth().currentUser else { return}
        
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profileImageView.bounds)
        
        storageService.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self](result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = displayName
                request?.photoURL = url
                request?.commitChanges(completion: { [unowned self](error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile update", message: "error changing profile \(error.localizedDescription)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile update", message: "Profile successfully updated")
                        }
                    }
                })
            }
        }
    }
    
    
    
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(storyboardName: "LoginScreen", viewControllerID: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "error signing out", message: "\(error.localizedDescription)")
            }
        }
    }
    

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
          return
        }
        selectedImage = image
        dismiss(animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
    // dismisses keyboard after Enter pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}
