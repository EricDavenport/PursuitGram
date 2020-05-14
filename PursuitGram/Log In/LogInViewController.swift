//
//  ViewController.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountState {
  case existingUser
  case newUser
}

class LogInViewController: UIViewController {

  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var loginLabel: UILabel!
  @IBOutlet weak var createAccountButton: UIButton!

  
  private var accountState : AccountState = .existingUser
  
  private var authSession = AuthenticationSession()
  private var db = DatabaseService()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textfieldSetup()
    // Do any additional setup after loading the view.
  }
  
  private func textfieldSetup() {
    emailTextField.delegate = self
    passwordTextField.delegate = self
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
      UIView.transition(with: loginLabel, duration: duration, options: [.transitionCrossDissolve], animations: {
        self.loginButton.setTitle("Sign in", for: .normal)
        self.loginLabel.text = "New User?"
        
      }, completion: nil)
    } else {
      UIView.transition(with: loginLabel, duration: duration, options: [.transitionCrossDissolve], animations: {
        self.loginButton.setTitle("Create Account", for: .normal)
        self.loginLabel.text = "Already have an account?"
      }, completion: nil)
    }
    
  }
  
  private func continueLogInFlow(email: String, password: String) {
    if accountState == .existingUser {
      authSession.signInExistingUser(email: email, password: password) { [weak self] (result) in
        switch result {
        case .failure(let error):
          print("Error signing in existing user: \(error)")
        case .success(let data):
          print("It works: New User accepted\(data.user.email ?? "")")
          print("account state login flow = \(self!.accountState)")

          self?.navigateToTabView()
        }
      }
    } else {
      authSession.createNewUser(email: email, password: password) { [weak self] (result) in
        switch result {
        case .failure(let error):
          print("error creating new user: \(error)")
        case .success(let data):
          print("It works - new user crested: welcome \(data.user.email ?? "")")
          self?.createDatabaseUser(authDataResult: data)
          self?.navigateToTabView()
        }
      }
    }
  }
  
  private func navigateToTabView() {
    UIViewController.showViewController(storyboardName: "Main", viewControllerId: "TabBarController")
    
  }
  
  private func createDatabaseUser(authDataResult: AuthDataResult) {
    db.createDatabaseUser(authDataResult: authDataResult) { (result) in
      switch result {
      case .failure(let error):
        print("Error: \(error)")
      case .success:
        print("it worked - db user created")
      }
    }
  }
  
  
  
  
}

extension LogInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
