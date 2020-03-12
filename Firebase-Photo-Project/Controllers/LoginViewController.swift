//
//  LoginViewController.swift
//  Firebase-Photo-Project
//
//  Created by Liubov Kaper  on 3/3/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit
import FirebaseAuth

// last day

enum AccountState {
  case existingUser
  case newUser
}

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var appNameLabel: UILabel!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    
    @IBOutlet weak var displayNameTextField: DesignableTextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var accountStateButton: UIButton!
    
    
    @IBOutlet weak var accountStateLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    private var accountState: AccountState = .existingUser
    
    private var authSession = AuthenticationSession()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearErrorLabel()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        displayNameTextField.delegate = self
        errorLabel.numberOfLines = 3
        emailTextField.keyboardType = UIKeyboardType.emailAddress

    }
   
    private func clearErrorLabel() {
      errorLabel.text = ""
    }

   
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty,
            let displayName = displayNameTextField.text,
            !displayName.isEmpty
            else {
                print("missing fields")
                return
        }
        continueLoginFlow(email: email, password: password, displayName: displayName)
        
    }
    
    private func continueLoginFlow(email: String, password: String, displayName: String) {
            if accountState == .existingUser {
                authSession.signExistingUser(email: email, password: password) {[weak self] (result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.errorLabel.text = "\(error.localizedDescription)"
                            self?.errorLabel.textColor = .systemRed
                        }
                    case .success:
                        let request = Auth.auth().currentUser?.createProfileChangeRequest()
                        request?.displayName = displayName
                        DispatchQueue.main.async {
                           self?.navigateToMainView()
                            
                           
                        }
                    }
                }
            } else {
                authSession.createNewUser(email: email, password: password, displayName: displayName) {[weak self] (result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.errorLabel.text = "\(error.localizedDescription)"
                            self?.errorLabel.textColor = .systemRed
                        }
                    case .success:
                        let request = Auth.auth().currentUser?.createProfileChangeRequest()
                        request?.displayName = displayName
                        request?.commitChanges(completion: { (error) in
                            if let error = error {
                                print("error saving displayName \(error)")
                                
                            } else {
                                print("display name was saved")

                            }
                        })
                        DispatchQueue.main.async {
                            self?.navigateToMainView()
                            
                            
                        }
                    }
                }
            }
        }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "MainView", viewControllerID: "MainTabBarController")
    }
    
    
    @IBAction func togglAccountStateButton(_ sender: UIButton) {
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        // animation duration
        let duration: TimeInterval = 1.0
        
        if accountState == .existingUser {
            UIView.transition(with: view, duration: duration, options: [.allowAnimatedContent], animations: {
            self.loginButton.setTitle("Login", for: .normal)
            self.accountStateLabel.text = "Don't have an account ? Click"
            self.accountStateButton.setTitle("SIGNUP", for: .normal)
          }, completion: nil)
        } else {
          UIView.transition(with: view, duration: duration, options: [.allowAnimatedContent], animations: {
            self.loginButton.setTitle("Sign Up", for: .normal)
            self.accountStateLabel.text = "Already have an account ?"
            self.accountStateButton.setTitle("LOGIN", for: .normal)
          }, completion: nil)
        }
    }
    
}
extension LoginViewController: UITextFieldDelegate {
    
    // dismisses keyboard after Enter pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}
