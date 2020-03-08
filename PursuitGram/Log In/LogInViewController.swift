//
//  ViewController.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

enum AccountState {
  case existingUser
  case newUser
}

class LogInViewController: UIViewController {

  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var createAccountButton: UIButton!
  @IBOutlet weak var buttonStack: UIStackView!
  
  private var accountState : AccountState = .existingUser
  
  private var authSession = AuthenticationSession()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  
  @IBAction func logInButtonPressed(_ sender: UIButton) {
    guard let email = emailTextField.text,
      !email.isEmpty,
      let password = passwordTextField.text,
      !password.isEmpty else {
        print("missing fields")
        return
    }
    print("success")
    continueLogInFlow(email: email, password: password)
  }
  
  
  
  @IBAction func createAccountButtonPressed(_ sender: UIButton) {
    accountState = accountState == .existingUser ? .newUser : .existingUser
    
    let duration : TimeInterval = 1.0
    
    if accountState == .existingUser {
      UIView.transition(with: buttonStack, duration: duration, options: [.transitionCrossDissolve], animations: {
        self.createAccountButton.setTitle("Login", for: .normal)
      }, completion: nil)
    } else {
      UIView.transition(with: buttonStack, duration: duration, options: [.transitionCrossDissolve], animations: {
        self.createAccountButton.setTitle("Sign Up", for: .normal)
      }, completion: nil)
    }
    
  }
  
  private func continueLogInFlow(email: String, password: String) {
    if accountState == .existingUser {
      authSession.signInExistingUser(email: email, password: password) { (result) in
        switch result {
        case .failure(let error):
          print("Error signing in existing user: \(error)")
        case .success(let data):
          print("It works: New User accepted\(data.user.email ?? "")")
        }
      }
    } else {
      authSession.createNewUser(email: email, password: password) { (result) in
        switch result {
        case .failure(let error):
          print("error creating new user: \(error)")
        case .success(let data):
          print("It works - new user crested: welcome \(data.user.email ?? "")")
        }
      }
    }
  }
  
  
  
  
}

