//
//  SettingViewController.swift
//  PursuitGram
//
//  Created by Eric Davenport on 3/8/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
  
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var updateButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()

   
    }
    
  @IBAction func updateButtonPreeesd(_ sender: UIButton) {
  }
  
  private func updateUI() {
    guard let user = Auth.auth().currentUser else { return }
    emailLabel.text = user.email
    
    
  }
  



}
